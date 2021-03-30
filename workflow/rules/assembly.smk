rule assembly_megahit:
    input:
        fastq1="results/{date}/nonhuman-reads/{sample}.1.fastq.gz",
        fastq2="results/{date}/nonhuman-reads/{sample}.2.fastq.gz",
    output:
        contigs="results/{date}/assembly/megahit/{sample}/{sample}.contigs.fa",
        read_count=temp("results/{date}/assembly/megahit/{sample}.log"),
    log:
        "logs/{date}/megahit/{sample}.log",
    params:
        outdir=lambda w, output: os.path.dirname(output[0]),
        sample=lambda wildcards: wildcards.sample,
    threads: 8
    conda:
        "../envs/megahit.yaml"
    shell:
        "(zcat {input.fastq1} |wc -l > {output.read_count} && "
        "megahit -1 {input.fastq1} -2 {input.fastq2} --out-dir {params.outdir} -f && "
        "mv {params.outdir}/final.contigs.fa {output.contigs} ) 2> {log}"


rule assembly_metaspades:
    input:
        fastq1="results/{date}/clipped-reads/{sample}.1.fastq.gz",
        fastq2="results/{date}/clipped-reads/{sample}.2.fastq.gz",
    output:
        contigs="results/{date}/assembly/metaspades/{sample}/contigs.fasta",
        read_count=temp("results/{date}/assembly/metaspades/{sample}.log"),
    params:
        outdir=lambda w, output: os.path.dirname(output[0]),
    log:
        "logs/{date}/metaSPAdes/{sample}.log",
    threads: 16
    conda:
        "../envs/spades.yaml"
    shell:
        "(zcat {input.fastq1} |wc -l > {output.read_count} && "
        "metaspades.py -1 {input.fastq1} -2 {input.fastq2} -o {params.outdir} -t {threads}) > {log} 2>&1"


rule mv_contigs:
    input:
        contigs=get_contigs,
    output:
        contigs=temp("results/{date}/assembly/{sample}.contigs.fasta"),
    log:
        "logs/{date}/mv_contigs/{sample}.log",
    conda:
        "../envs/unix.yaml"
    shell:
        "(cp {input.contigs} {output.contigs}) > {log} 2>&1"


rule mv_assembly_read_counts:
    input:
        read_counts=get_read_counts,
    output:
        read_counts=temp("results/{date}/assembly/{sample}.log"),
    log:
        "logs/{date}/mv_read_counts/{sample}.log",
    conda:
        "../envs/unix.yaml"
    shell:
        "(cp {input.read_counts} {output.read_counts}) > {log} 2>&1"


rule order_contigs:
    input:
        contigs=get_contigs,
        reference="resources/genomes/main.fasta",
    output:
        temp("results/{date}/ordered-contigs-all/{sample}.fasta"),
    log:
        "logs/{date}/ragoo/{sample}.log",
    params:
        outdir=lambda x, output: os.path.dirname(output[0]),
    threads: 8
    conda:
        "../envs/ragoo.yaml"
    shell:  # currently there is no conda package for mac available. Manuell download via https://github.com/malonge/RaGOO
        "(mkdir -p {params.outdir}/{wildcards.sample} && cd {params.outdir}/{wildcards.sample} && "
        "ragoo.py ../../../../{input.contigs} ../../../../{input.reference} && "
        "cd ../../../../ && mv {params.outdir}/{wildcards.sample}/ragoo_output/ragoo.fasta {output}) > {log} 2>&1"


rule filter_chr0:
    input:
        "results/{date}/ordered-contigs-all/{sample}.fasta",
    output:
        "results/{date}/ordered-contigs/{sample}.fasta",
    log:
        "logs/{date}/ragoo/{sample}_cleaned.log",
    params:
        sample=lambda wildcards: wildcards.sample,
    conda:
        "../envs/python.yaml"
    script:
        "../scripts/ragoo-remove-chr0.py"


rule polish_contigs:
    input:
        fasta="results/{date}/ordered-contigs/{sample}.fasta",
        bcf="results/{date}/filtered-calls/ref~{sample}/{sample}.clonal.nofilter.bcf",
        bcfidx="results/{date}/filtered-calls/ref~{sample}/{sample}.clonal.nofilter.bcf.csi",
    output:
        report(
            "results/{date}/polished-contigs/{sample}.fasta",
            category="5. Assembly",
            caption="../report/assembly.rst",
        ),
    log:
        "logs/{date}/bcftools-consensus/{sample}.log",
    conda:
        "../envs/bcftools.yaml"
    shell:
        "bcftools consensus -f {input.fasta} {input.bcf} > {output} 2> {log}"


rule align_contigs:
    input:
        target="resources/genomes/main.fasta",
        query=get_quast_fastas,
    output:
        "results/{date}/aligned/ref~main/{stage}~{sample}.bam",
    log:
        "results/{date}/aligned/ref~main/{stage}~{sample}.log",
    conda:
        "../envs/minimap2.yaml"
    shell:
        "minimap2 -ax asm5 {input.target} {input.query} -o {output} 2> {log}"


rule quast:
    input:
        fasta=get_quast_fastas,
        bam="results/{date}/aligned/ref~main/{stage}~{sample}.bam",
        reference="resources/genomes/main.fasta",
    output:
        "results/{date}/quast/{stage}/{sample}/report.tsv",
    params:
        outdir=lambda x, output: os.path.dirname(output[0]),
    log:
        "logs/{date}/quast/{stage}/{sample}.log",
    conda:
        "../envs/quast.yaml"
    threads: 8
    shell:
        "quast.py --min-contig 1 --threads {threads} -o {params.outdir} -r {input.reference} --bam {input.bam} {input.fasta} > {log} 2>&1"


# TODO blast smaller contigs to determine contamination?
