# source: https://nf-co.re/viralrecon/2.2/usage#usage
rule download_viralrecon_script:
    output:
        "resources/benchmarking/nf-core-viralrecon/fastq_dir_to_samplesheet.py",
    log:
        "logs/download_viralrecon_script.log",
    conda:
        "../envs/unix.yaml"
    shell:
        "(wget -L https://raw.githubusercontent.com/nf-core/viralrecon/master/bin/fastq_dir_to_samplesheet.py -O {output} &&"
        " chmod 755 {output})"
        " > {log} 2>&1"


rule nf_core_viralrecon_illumina_sample_sheet:
    output:
        "results/benchmarking/nf-core-viralrecon/illumina/sample-sheets/{sample}.csv",
    log:
        "logs/nf_core_viralrecon_illumina_sample_sheet/{sample}.log",
    conda:
        "../../envs/unix.yaml"
    params:
        string=lambda w: get_barcode_for_viralrecon_illumina_sample(w),
    shell:
        "echo '{params.string}' > {output} 2> {log}"


rule nf_core_viralrecon_illumina:
    input:
        input="results/benchmarking/nf-core-viralrecon/illumina/sample-sheets/{sample}.csv",
    output:
        outdir=temp(
            directory("results/benchmarking/nf-core-viralrecon/illumina/{sample}")
        ),
        de_novo_assembly="results/benchmarking/nf-core-viralrecon/illumina/{sample}/assembly/spades/rnaviral/{sample}.contigs.fa",
        pangolin="results/benchmarking/nf-core-viralrecon/illumina/{sample}/variants/bcftools/pangolin/{sample}.pangolin.csv",
        consensus="results/benchmarking/nf-core-viralrecon/illumina/{sample}/variants/bcftools/consensus/{sample}.consensus.fa",
        vcf="results/benchmarking/nf-core-viralrecon/illumina/{sample}/variants/bcftools/{sample}.vcf.gz",
    log:
        "logs/nf-core-viralrecon/{sample}.log",
    conda:
        "../../envs/nextflow.yaml"
    benchmark:
        "benchmarks/nf_core_viralrecon_illumina/{sample}.benchmark.txt"
    threads: 4
    resources:
        external_pipeline=1,
        nextflow=1,
    params:
        pipeline="nf-core/viralrecon",
        revision="2.2",
        qs=lambda w, threads: threads,
        profile=["docker"],
        platform="illumina",
        protocol="metagenomic",
        genome="'MN908947.3'",
        outdir="results/benchmarking/nf-core-viralrecon/illumina/{sample}",
        cleanup=True,
    handover: True
    script:
        "../../scripts/nextflow.py"


rule nf_core_viralrecon_illumina_extract_vcf_gz:
    input:
        "results/benchmarking/nf-core-viralrecon/illumina/{sample}/variants/bcftools/{sample}.vcf.gz",
    output:
        "results/benchmarking/nf-core-viralrecon/illumina/{sample}.vcf",
    log:
        "logs/nf_core_viralrecon_illumina_extract_vcf_gz/{sample}.log",
    conda:
        "../../envs/unix.yaml"
    shell:
        "gzip -dk -c {input} > {output}"


rule nf_core_viralrecon_nanopore_sample_sheet:
    output:
        "results/benchmarking/nf-core-viralrecon/nanopore/sample-sheets/{sample}/sample_sheet.csv",
    log:
        "logs/nf_core_viralrecon_nanopore_sample_sheet/{sample}.log",
    conda:
        "../../envs/unix.yaml"
    params:
        string=lambda w: get_barcode_for_viralrecon_nanopore_sample(w),
    shell:
        "echo '{params.string}' > {output} 2> {log}"


rule nf_core_viralrecon_nanopore_prepare_samples:
    input:
        get_fastq_or_fast5,
    output:
        temp(
            directory(
                "resources/benchmarking/data/nf-core-viralrecon/{sample}/{folder}/"
            )
        ),
    log:
        "logs/nf_core_viralrecon_nanopore_prepare_samples/{sample}-{folder}.log",
    conda:
        "../../envs/unix.yaml"
    params:
        barcode=lambda w, output: os.path.join(output[0], get_barcode(w)),
        mv_or_uncompress=lambda w, output: f" && cd {output[0]}/{get_barcode(w)} && gunzip -dk *.gz"
        if w.folder == "fastq_pass"
        else "",
    shell:
        "(mkdir -p {params.barcode} &&"
        " cp -r {input} {output}{params.mv_or_uncompress})"
        "2>{log}"


use rule nf_core_viralrecon_illumina as nf_core_viralrecon_nanopore_nanopolish with:
    input:
        input="results/benchmarking/nf-core-viralrecon/nanopore/sample-sheets/{sample}/sample_sheet.csv",
        sequencing_summary=lambda wildcards: get_seq_summary(wildcards),
        fastq_dir="resources/benchmarking/data/nf-core-viralrecon/{sample}/fastq_pass/",
        fast5_dir="resources/benchmarking/data/nf-core-viralrecon/{sample}/fast5_pass/",
    output:
        outdir=temp(
            directory(
                "results/benchmarking/nf-core-viralrecon/nanopore/nanopolish/{sample}"
            )
        ),
        consensus="results/benchmarking/nf-core-viralrecon/nanopore/nanopolish/{sample}/nanopolish/{sample}.consensus.fasta",
        pangolin="results/benchmarking/nf-core-viralrecon/nanopore/nanopolish/{sample}/nanopolish/pangolin/{sample}.pangolin.csv",
        vcf="results/benchmarking/nf-core-viralrecon/nanopore/nanopolish/{sample}/nanopolish/{sample}.merged.vcf",
    log:
        "logs/nf-core-nf_core_viralrecon_nanopore/nanopolish/{sample}.log",
    benchmark:
        "benchmarks/nf_core_viralrecon_nanopolish/{sample}.benchmark.txt"
    params:
        pipeline="nf-core/viralrecon",
        revision="2.2",
        qs=lambda w, threads: threads,
        profile=["docker"],
        platform="nanopore",
        genome="'MN908947.3'",
        primer_set_version=3,
        outdir="results/benchmarking/nf-core-viralrecon/nanopore/nanopolish/{sample}",


use rule nf_core_viralrecon_nanopore_nanopolish as nf_core_viralrecon_nanopore_medaka with:
    output:
        outdir=temp(
            directory(
                "results/benchmarking/nf-core-viralrecon/nanopore/medaka/{sample}/"
            )
        ),
        consensus="results/benchmarking/nf-core-viralrecon/nanopore/medaka/{sample}/medaka/{sample}.consensus.fasta",
        pangolin="results/benchmarking/nf-core-viralrecon/nanopore/medaka/{sample}/medaka/pangolin/{sample}.pangolin.csv",
        vcf="results/benchmarking/nf-core-viralrecon/nanopore/medaka/{sample}/medaka/{sample}.merged.vcf",
    log:
        "logs/nf-core-nf_core_viralrecon_nanopore/medaka/{sample}.log",
    benchmark:
        "benchmarks/nf_core_viralrecon_medaka/{sample}.benchmark.txt"
    params:
        pipeline="nf-core/viralrecon",
        revision="2.2",
        qs=lambda w, threads: threads,
        profile=["docker"],
        platform="nanopore",
        genome="'MN908947.3'",
        primer_set_version=3,
        artic_minion_caller="medaka",
        artic_minion_medaka_model=config["medaka_model"],
        outdir="results/benchmarking/nf-core-viralrecon/nanopore/medaka/{sample}",