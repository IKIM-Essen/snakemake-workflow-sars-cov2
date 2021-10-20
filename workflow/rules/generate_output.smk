# Copyright 2021 Thomas Battenfeld, Alexander Thomas, Johannes Köster.
# Licensed under the BSD 2-Clause License (https://opensource.org/licenses/BSD-2-Clause)
# This file may not be copied, modified, or distributed
# except according to those terms.


rule masking:
    input:
        bamfile="results/{date}/mapped/ref~polished-{sample}/{sample}.bam",
        bai="results/{date}/mapped/ref~polished-{sample}/{sample}.bam.bai",
        sequence="results/{date}/contigs/polished/{sample}.fasta",
    output:
        masked_sequence="results/{date}/contigs/masked/{sample}.fasta",
        coverage="results/{date}/tables/coverage/{sample}.txt",
    params:
        min_coverage=config["quality-criteria"]["min-depth-with-PCR-duplicates"],
        min_allele=config["quality-criteria"]["min-allele"],
    log:
        "logs/{date}/masking/{sample}.logs",
    conda:
        "../envs/pysam.yaml"
    script:
        "../scripts/mask-contigs.py"


rule plot_coverage_main_sequence:
    input:
        expand_samples_for_date("results/{{date}}/qc/samtools_depth/{sample}.txt"),
    output:
        report(
            "results/{date}/plots/coverage-reference-genome.svg",
            caption="../report/all-main-coverage.rst",
            category="3. Sequencing Details",
            subcategory="2. Read Coverage of Reference Genome",
        ),
    params:
        min_coverage=config["quality-criteria"]["min-depth-with-PCR-duplicates"],
    log:
        "logs/{date}/plot-coverage-main-seq.log",
    conda:
        "../envs/python.yaml"
    script:
        "../scripts/plot-all-coverage.py"


rule plot_coverage_final_sequence:
    input:
        expand_samples_for_date("results/{{date}}/tables/coverage/{sample}.txt"),
    output:
        report(
            "results/{date}/plots/coverage-assembled-genome.svg",
            caption="../report/all-final-coverage.rst",
            category="3. Sequencing Details",
            subcategory="3. Read Coverage of Reconstructed Genome",
        ),
    params:
        min_coverage=config["quality-criteria"]["min-depth-with-PCR-duplicates"],
    log:
        "logs/{date}/plot-coverage-final-seq.log",
    conda:
        "../envs/python.yaml"
    script:
        "../scripts/plot-all-coverage.py"


checkpoint rki_filter:
    input:
        quast=get_final_assemblies_identity,
        contigs=get_final_assemblies,
    output:
        "results/{date}/rki-filter/{assembly_type}.txt",
    params:
        min_identity=config["quality-criteria"]["min-identity"],
        max_n=config["quality-criteria"]["max-n"],
    log:
        "logs/{date}/rki-filter/{assembly_type}.log",
    conda:
        "../envs/python.yaml"
    script:
        "../scripts/rki-filter.py"


rule rki_report:
    input:
        contigs=lambda wildcards: get_assemblies_for_submission(
            wildcards, "accepted samples"
        ),
    output:
        fasta=report(
            "results/rki/{date}_uk-essen_rki.fasta",
            category="6. RKI Submission",
            caption="../report/rki-submission-fasta.rst",
        ),
        table=report(
            "results/rki/{date}_uk-essen_rki.csv",
            category="6. RKI Submission",
            caption="../report/rki-submission-csv.rst",
        ),
    conda:
        "../envs/pysam.yaml"
    log:
        "logs/{date}/rki-output/{date}.log",
    script:
        "../scripts/generate-rki-output.py"


rule virologist_report:
    input:
        reads_unfiltered=get_fastp_results,
        reads_used_for_assembly=expand_samples_for_date(
            "results/{{date}}/tables/read_pair_counts/{sample}.txt",
        ),
        initial_contigs=get_expanded_contigs,
        polished_contigs=expand_samples_for_date(
            "results/{{date}}/contigs/polished/{sample}.fasta",
        ),
        pseudo_contigs=expand_samples_for_date(
            "results/{{date}}/contigs/pseudoassembled/{sample}.fasta",
        ),
        kraken=get_kraken_output,
        pangolin=expand_samples_for_date(
            "results/{{date}}/tables/strain-calls/{sample}.strains.pangolin.csv",
        ),
        bcf=expand_samples_for_date(
            "results/{{date}}/filtered-calls/ref~main/{sample}.subclonal.high+moderate-impact.bcf",
        ),
    output:
        qc_data="results/{date}/virologist/qc_report.csv",
    params:
        assembly_used=lambda wildcards: get_assemblies_for_submission(
            wildcards, "all samples"
        ),
        voc=config.get("voc"),
        samples=lambda wildcards: get_samples_for_date(wildcards.date),
    log:
        "logs/{date}/overview-table.log",
    conda:
        "../envs/pysam.yaml"
    script:
        "../scripts/generate-overview-table.py"


rule qc_html_report:
    input:
        "results/{date}/virologist/qc_report.csv",
    output:
        report(
            directory("results/{date}/qc_data/"),
            htmlindex="index.html",
            caption="../report/qc-report.rst",
            category="1. Overview",
            subcategory="1. QC Report",
        ),
    params:
        formatter=get_resource("report-table-formatter.js"),
        pin_until="Sample",
    log:
        "logs/{date}/qc_report_html.log",
    conda:
        "../envs/rbt.yaml"
    shell:
        "rbt csv-report {input} --formatter {params.formatter} --pin-until {params.pin_until} {output} > {log} 2>&1"


rule plot_lineages_over_time:
    input:
        lambda wildcards: expand(
            "results/{date}/tables/strain-calls/{sample}.strains.pangolin.csv",
            zip,
            date=get_dates_before_date(wildcards),
            sample=get_samples_before_date(wildcards),
        ),
    output:
        report(
            "results/{date}/plots/lineages-over-time.svg",
            caption="../report/lineages-over-time.rst",
            category="1. Overview",
            subcategory="2. Lineages Development",
        ),
        "results/{date}/tables/lineages-over-time.csv",
    params:
        dates=get_dates_before_date,
    log:
        "logs/{date}/plot_lineages_over_time.log",
    conda:
        "../envs/python.yaml"
    script:
        "../scripts/plot-lineages-over-time.py"


rule snakemake_reports:
    input:
        "results/{date}/plots/lineages-over-time.svg",
        "results/{date}/plots/coverage-reference-genome.svg",
        "results/{date}/plots/coverage-assembled-genome.svg",
        lambda wildcards: expand(
            "results/{{date}}/contigs/polished/{sample}.fasta",
            sample=get_samples_for_date(wildcards.date),
        ),
        lambda wildcards: expand(
            "results/{{date}}/plots/strain-calls/{sample}.strains.kallisto.svg",
            sample=get_samples_for_date(wildcards.date),
        ),
        "results/{date}/qc_data",
        expand(
            "results/{{date}}/plots/all.{mode}-strain.strains.kallisto.svg",
            mode=["major"],
        ),
        "results/{date}/plots/all.strains.pangolin.svg",
        lambda wildcards: expand(
            "results/{{date}}/vcf-report/{target}.{filter}",
            target=get_samples_for_date(wildcards.date) + ["all"],
            filter=config["variant-calling"]["filters"],
        ),
        "results/{date}/qc/laboratory/multiqc.html",
        "results/rki/{date}_uk-essen_rki.csv",
        "results/rki/{date}_uk-essen_rki.fasta",
        expand(
            "results/{{date}}/ucsc-vcfs/all.{{date}}.{filter}.vcf",
            filter=config["variant-calling"]["filters"],
        ),
        lambda wildcards: "results/{date}/plots/primer-clipping-intervals.svg"
        if len(get_samples_for_date_for_illumina_amplicon(wildcards.date)) > 0
        else [],
    output:
        "results/reports/{date}.zip",
    params:
        for_testing=get_if_testing("--snakefile ../workflow/Snakefile"),
    conda:
        "../envs/snakemake.yaml"
    log:
        "logs/snakemake_reports/{date}.log",
    shell:
        "snakemake --nolock --report-stylesheet resources/custom-stylesheet.css {input} "
        "--report {output} {params.for_testing} "
        "> {log} 2>&1"
