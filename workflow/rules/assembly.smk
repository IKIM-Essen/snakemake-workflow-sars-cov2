rule count_assembly_reads:
    input:
        fastq1=lambda wildcards: get_reads_after_qc(wildcards, read="1"),
    output:
        read_count=temp("results/{date}/tables/read_pair_counts/{sample}.txt"),
    log:
        "logs/{date}/read_pair_counts/{sample}.log",
    conda:
        "../envs/unix.yaml"
    shell:
        '(echo "$(( $(zcat {input.fastq1} | wc -l) / 4 ))" > {output.read_count}) 2> {log}'


rule assembly_megahit:
    input:
        fastq1="results/{date}/nonhuman-reads/{sample}.1.fastq.gz",
        fastq2="results/{date}/nonhuman-reads/{sample}.2.fastq.gz",
    output:
        contigs="results/{date}/assembly/megahit/{sample}/{sample}.contigs.fasta",
    log:
        "logs/{date}/megahit/{sample}.log",
    params:
        outdir=get_output_dir,
    conda:
        "../envs/megahit.yaml"
    threads: 8
    shell:
        "(megahit -1 {input.fastq1} -2 {input.fastq2} --out-dir {params.outdir} -f &&"
        " mv {params.outdir}/final.contigs.fa {output.contigs} )"
        " > {log} 2>&1"


rule assembly_metaspades:
    input:
        fastq1="results/{date}/clipped-reads/{sample}.1.fastq.gz",
        fastq2="results/{date}/clipped-reads/{sample}.2.fastq.gz",
    output:
        contigs="results/{date}/assembly/metaspades/{sample}/{sample}.contigs.fasta",
    params:
        outdir=get_output_dir,
    log:
        "logs/{date}/metaSPAdes/{sample}.log",
    conda:
        "../envs/spades.yaml"
    threads: 8
    shell:
        "(metaspades.py -1 {input.fastq1} -2 {input.fastq2} -o {params.outdir} -t {threads} &&"
        " mv {params.outdir}/contigs.fasta {output.contigs})"
        " > {log} 2>&1"


rule order_contigs:
    input:
        contigs=get_contigs,
        reference="resources/genomes/main.fasta",
    output:
        temp("results/{date}/contigs/ordered-unfiltered/{sample}.fasta"),
    log:
        "logs/{date}/ragoo/{sample}.log",
    params:
        outdir=get_output_dir,
    conda:
        "../envs/ragoo.yaml"
    shadow:
        "minimal"
    shell:
        "(mkdir -p {params.outdir}/{wildcards.sample} && cd {params.outdir}/{wildcards.sample} &&"
        " ragoo.py ../../../../../{input.contigs} ../../../../../{input.reference} &&"
        " cd ../../../../../ && mv {params.outdir}/{wildcards.sample}/ragoo_output/ragoo.fasta {output})"
        " > {log} 2>&1"


rule filter_chr0:
    input:
        "results/{date}/contigs/ordered-unfiltered/{sample}.fasta",
    output:
        temp("results/{date}/contigs/ordered/{sample}.fasta"),
    log:
        "logs/{date}/ragoo/{sample}_cleaned.log",
    conda:
        "../envs/python.yaml"
    script:
        "../scripts/ragoo-remove-chr0.py"


rule polish_contigs:
    input:
        fasta="results/{date}/contigs/ordered/{sample}.fasta",
        bcf="results/{date}/filtered-calls/ref~{sample}/{sample}.clonal.nofilter.bcf",
        bcfidx="results/{date}/filtered-calls/ref~{sample}/{sample}.clonal.nofilter.bcf.csi",
    output:
        report(
            "results/{date}/contigs/polished/{sample}.fasta",
            category="4. Assembly",
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
        temp("results/{date}/aligned/ref~main/{stage}~{sample}.bam"),
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
        temp("results/{date}/quast/{stage}/{sample}/report.tsv"),
    params:
        outdir=get_output_dir,
    log:
        "logs/{date}/quast/{stage}/{sample}.log",
    conda:
        "../envs/quast.yaml"
    threads: 8
    shell:
        "quast.py --min-contig 1 --threads {threads} -o {params.outdir} -r {input.reference} "
        "--bam {input.bam} {input.fasta} "
        "> {log} 2>&1"
