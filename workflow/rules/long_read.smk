rule nanoQC:
    input:
        get_reads_by_stage,
    output:
        "results/{date}/qc/nanoQC/{sample}/{stage}/nanoQC.html",
    log:
        "logs/{date}/nanoQC/{sample}_{stage}.log",
    params:
        outdir=get_output_dir,
    conda:
        "../envs/nanoqc.yaml"
    shell:
        "nanoQC {input} -o {params.outdir} > {log} 2>&1"


rule count_fastq_reads:
    input:
        get_reads_by_stage,
    output:
        "results/{date}/tables/fastq-read-counts/{stage}~{sample}.txt",
    log:
        "logs/{date}/count_reads/{stage}~{sample}.log",
    conda:
        "../envs/unix.yaml"
    shell:
        "echo $(( $(cat {input} | wc -l ) / 4)) > {output} 2> {log}"


rule porechop_adapter_barcode_trimming:
    input:
        get_fastqs,
    output:
        "results/{date}/trimmed/porechop/adapter_barcode_trimming/{sample}.fastq",
    conda:
        "../envs/porechop.yaml"
    log:
        "logs/{date}/trimmed/porechop/adapter_barcode_trimming/{sample}.log",
    threads: 2
    shell:
        "porechop -i {input} -o {output} --threads {threads} -v 1 > {log} 2>&1"


rule customize_primer_porechop:
    input:
        get_artic_primer,
    output:
        "results/tables/replacement_notice.txt",
    conda:
        "../envs/primechop.yaml"
    log:
        "logs/customize_primer_porechop.log",
    shell:
        "(cp {input} $CONDA_PREFIX/lib/python3.6/site-packages/porechop/adapters.py && "
        'echo "replaced adpaters in adapter.py file in $CONDA_PREFIX/lib/python3.6/site-packages/porechop/adapters.py with ARTICv3 primers" > {output}) '
        "2> {log}"


rule porechop_primer_trimming:
    input:
        fastq_in="results/{date}/trimmed/porechop/adapter_barcode_trimming/{sample}.fastq",
        repl_flag="results/tables/replacement_notice.txt",
    output:
        "results/{date}/trimmed/porechop/primer_clipped/{sample}.fastq",
    conda:
        "../envs/primechop.yaml"
    log:
        "logs/{date}/trimmed/porechop/primer_clipped/{sample}.log",
    threads: 2
    shell:
        "porechop -i {input.fastq_in} -o {output} --no_split --end_size 35 --extra_end_trim 0 --threads {threads} -v 1 > {log} 2>&1"


rule nanofilt:
    input:
        "results/{date}/trimmed/porechop/primer_clipped/{sample}.fastq",
    output:
        "results/{date}/trimmed/nanofilt/{sample}.fastq",
    log:
        "logs/{date}/nanofilt/{sample}.log",
    params:
        min_length=config["quality-criteria"]["ont"]["min-length-reads"],
        min_PHRED=config["quality-criteria"]["ont"]["min-PHRED"],
    conda:
        "../envs/nanofilt.yaml"
    shell:
        "NanoFilt --length {params.min_length} --quality {params.min_PHRED} --maxlength 500 {input} > {output} 2> {log}"


# correction removes PHRED score
rule canu_correct:
    input:
        "results/{date}/trimmed/nanofilt/{sample}.fastq",
    output:
        "results/{date}/corrected/{sample}/{sample}.correctedReads.fasta.gz",
    log:
        "logs/{date}/canu/assemble/{sample}.log",
    params:
        outdir=get_output_dir,
        min_length=config["quality-criteria"]["ont"]["min-length-reads"],
        for_testing=lambda w, threads: get_if_testing(
            f"corThreads={threads} redThreads={threads} redMemory=6 oeaMemory=6"
        ),
    conda:
        "../envs/canu.yaml"
    threads: 6
    shell:
        "( if [ -d {params.outdir} ]; then rm -Rf {params.outdir}; fi &&"
        " canu -correct -nanopore {input} -p {wildcards.sample} -d {params.outdir}"
        " genomeSize=30k corOverlapper=minimap utgOverlapper=minimap obtOverlapper=minimap"
        " minOverlapLength=10 minReadLength={params.min_length} corMMapMerSize=10 corOutCoverage=50000"
        " corMinCoverage=0 maxInputCoverage=20000 maxThreads={threads} {params.for_testing}) "
        " 2> {log}"


# rule unzip_canu:
#     input:
#         "results/{date}/corrected/{sample}/{sample}.correctedReads.fasta.gz",
#     output:
#         "results/{date}/corrected/{sample}/{sample}.correctedReads.fasta",
#     log:
#         "logs/{date}/unzip_canu/{sample}.log",
#     conda:
#         "../envs/unix.yaml"
#     shell:
#         "gzip -d {input}"


# rule medaka_consensus_reference:
use rule assembly_polishing_ont as medaka_consensus_reference with:
    input:
        fasta="results/{date}/corrected/{sample}/{sample}.correctedReads.fasta.gz",
        reference="resources/genomes/main.fasta",
    output:
        "results/{date}/consensus/medaka/{sample}/consensus.fasta",


rule rename_conensus:
    input:
        "results/{date}/consensus/medaka/{sample}/consensus.fasta",
    output:
        report(
            "results/{date}/contigs/consensus/{sample}.fasta",
            category="4. Assembly",
            subcategory="3. Consensus Sequences",
        ),
    log:
        "logs/{date}/rename-conensus-fasta/{sample}.log",
    conda:
        "../envs/unix.yaml"
    shell:
        "(cp {input} {output} && "
        ' sed -i "1s/.*/>{wildcards.sample}/" {output})'
        " 2> {log}"


# rule bcftools_consensus_ont:
#     input:
#         fasta="results/{date}/consensus/medaka/{sample}/consensus.fasta",
#         bcf="results/{date}/filtered-calls/ref~{sample}/{sample}.clonal.nofilter.bcf",
#         bcfidx="results/{date}/filtered-calls/ref~{sample}/{sample}.clonal.nofilter.bcf.csi",
#     output:
#         report(
#             "results/{date}/consensus/{sample}.fasta",
#             category="4. Assembly",
#             caption="../report/assembly_ont.rst",
#         ),
#     log:
#         "logs/{date}/bcftools-consensus-ont/{sample}.log",
#     conda:
#         "../envs/bcftools.yaml"
#     shell:
#         "bcftools consensus -f {input.fasta} {input.bcf} > {output} 2> {log}"
