rule simulate_strain_reads:
    input:
        "resources/genomes/{accession}.fasta",
    output:
        left="resources/{use_case}/{accession}/reads.1.fastq.gz",
        right="resources/{use_case}/{accession}/reads.2.fastq.gz",
    log:
        "logs/mason/{use_case}/{accession}.log",
    conda:
        "../envs/mason.yaml"
    shell:  # median reads in data: 584903
        "mason_simulator -ir {input} -n 584903 -o {output.left} -or {output.right} 2> {log}"


rule test_benchmark_results:
    input:
        get_benchmark_results,
    output:
        "results/benchmarking/strain-calling.csv",
    params:
        true_accessions=get_strain_accessions,
    log:
        "logs/test-benchmark-results.log",
    conda:
        "../envs/python.yaml"
    notebook:
        "../notebooks/test-benchmark-results.py.ipynb"


rule test_assembly_results:
    input:
        "resources/genomes/{accession}.fasta",
        get_assembly_result,
    output:
        "results/benchmarking/assembly/{assembly_type}/{accession}.bam",
    log:
        "logs/test-assembly-results/{assembly_type}/{accession}.log",
    conda:
        "../envs/minimap2.yaml"
    shell:
        "minimap2 --MD --eqx -ax asm5 {input} -o {output} 2> {log}"


rule summarize_assembly_results:
    input:
        bams=get_assembly_comparisons(bams=True),
        refs=get_assembly_comparisons(bams=False),
    output:
        "results/benchmarking/assembly/{assembly_type}.csv",
    log:
        "logs/summarize-assembly-results/{assembly_type}/assembly-results.log",
    conda:
        "../envs/pysam.yaml"
    notebook:
        "../notebooks/assembly-benchmark-results.py.ipynb"


rule test_non_cov2:
    input:
        pangolin=get_non_cov2_calls(from_caller="pangolin"),
        kallisto=get_non_cov2_calls(from_caller="kallisto"),
    output:
        "results/benchmarking/non-sars-cov-2.csv",
    params:
        accessions=get_non_cov2_accessions(),
    log:
        "logs/benchmarking/summarize_non_cov2.log",
    conda:
        "../envs/python.yaml"
    script:
        "../scripts/summarize-non-cov2.py"


rule report_non_cov2:
    input:
        summary="results/benchmarking/non-sars-cov-2.csv",
        call_plots=expand(
            "results/benchmarking/plots/strain-calls/non-cov2-{accession}.strains.{caller}.svg",
            accession=get_non_cov2_accessions(),
            caller=["pangolin", "kallisto"],
        ),
    output:
        report(
            directory("results/benchmarking/html"),
            htmlindex="index.html",
            category="Test results",
        ),
    log:
        "logs/report_non_cov2.log",
    conda:
        "../envs/rbt.yaml"
    shell:
        "rbt csv-report -s '\t' {input.summary} {output}"

rule get_read_length_statistics:
    input:
        expand("results/{date}/tables/read_pair_counts/{sample}.txt", zip, date = get_dates(), sample=get_samples()), 
    output:
        "results/benchmarking/tables/read_statistics.txt",
    log:
        "logs/get_read_statistics.log"
    conda:
        "../envs/python.yaml"
    script:
        "../scripts/get-read-statistics.py"
