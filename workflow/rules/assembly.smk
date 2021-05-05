rule count_assembly_reads:
    input:
        fastq1=lambda wildcards: get_reads_after_qc(wildcards, read="1"),
    output:
        read_count=temp("results/{date}/tables/read_counts/{sample}.txt"),
    log:
        "logs/{date}/read_counts/{sample}.log",
    threads: 1
    conda:
        "../envs/unix.yaml"
    shell:
        "zcat {input.fastq1} |wc -l > {output.read_count} 2> {log}"


rule pear_merge:
    input:
        read1=lambda wildcards: get_reads_after_qc(wildcards, read="1"),
        read2=lambda wildcards: get_reads_after_qc(wildcards, read="2"),
    output:
        assembled="results/{date}/merged-reads/pear/{sample}_assembled.fq.gz",
        discarded="results/{date}/merged-reads/pear/{sample}_discarded.fq.gz",
        unassembled_read1=(
            "results/{date}/merged-reads/pear/{sample}_unassembled_r1.fq.gz"
        ),
        unassembled_read2=(
            "results/{date}/merged-reads/pear/{sample}_unassembled_r2.fq.gz"
        ),
    log:
        "logs/{date}/pear/{sample}.log",
    params:
        pval=".01",
        extra="",
    threads: 4
    wrapper:
        "0.74.0/bio/pear"


rule bbmerge_merge:
    input:
        read1=lambda wildcards: get_reads_after_qc(wildcards, read="1"),
        read2=lambda wildcards: get_reads_after_qc(wildcards, read="2"),
    output:
        merged="results/{date}/merged-reads/bbmerge/{sample}/{sample}_merged.fq",
        unmerged="results/{date}/merged-reads/bbmerge/{sample}/{sample}_unmerged.fq",
        ihist="results/{date}/merged-reads/bbmerge/{sample}/{sample}_ihist.txt",
    log:
        "logs/{date}/bbmerge_merge/{sample}.log",
    conda:
        "../envs/bbmap.yaml"
    shell:
        "(bbmerge.sh in1={input.read1} in2={input.read2} out={output.merged} "
        "outu={output.unmerged} ihist={output.ihist}) 2> {log}"


rule assembly_minimus:
    input:
        "results/{date}/merged-reads/pear/{sample}_assembled.fq.gz",
    output:
        contigs="results/{date}/assembly/minimus/{sample}/{sample}.fasta",
        reads_fasta=temp(
            "results/{date}/assembly/minimus/{sample}/reads_{sample}.fasta"
        ),
        afg=temp("results/{date}/assembly/minimus/{sample}/{sample}.afg"),
    log:
        "logs/{date}/assembly_minimus/{sample}.log",
    params:
        outdir=lambda w, output: os.path.dirname(output[0]),
    conda:
        "../envs/minimus.yaml"
    shell:
        "(seqtk seq -a {input} > {output.reads_fasta} && "
        "toAmos -s {output.reads_fasta} -o {output.afg} && "
        "cd {params.outdir} && "
        "minimus {wildcards.sample} && "
        "mv my_reads.fasta {wildcards.sample}.fasta) > {log} 2>&1"


rule assembly_megahit:
    input:
        fastq1="results/{date}/nonhuman-reads/{sample}.1.fastq.gz",
        fastq2="results/{date}/nonhuman-reads/{sample}.2.fastq.gz",
    output:
        contigs="results/{date}/assembly/megahit/{sample}/{sample}.contigs.fasta",
    log:
        "logs/{date}/megahit/{sample}.log",
    params:
        outdir=lambda w, output: os.path.dirname(output[0]),
    threads: 8
    conda:
        "../envs/megahit.yaml"
    shell:
        "(megahit -1 {input.fastq1} -2 {input.fastq2} --out-dir {params.outdir} -f && "
        "mv {params.outdir}/final.contigs.fa {output.contigs} ) > {log} 2>&1"


rule assembly_metaspades:
    input:
        fastq1="results/{date}/clipped-reads/{sample}.1.fastq.gz",
        fastq2="results/{date}/clipped-reads/{sample}.2.fastq.gz",
    output:
        contigs="results/{date}/assembly/metaspades/{sample}/{sample}.contigs.fasta",
    params:
        outdir=lambda w, output: os.path.dirname(output[0]),
    log:
        "logs/{date}/metaSPAdes/{sample}.log",
    threads: 8
    conda:
        "../envs/spades.yaml"
    shell:
        "(metaspades.py -1 {input.fastq1} -2 {input.fastq2} -o {params.outdir} -t {threads} && "
        "mv {params.outdir}/contigs.fasta {output.contigs}) > {log} 2>&1"


rule order_contigs:
    input:
        contigs="results/{date}/assembly/minimus/{sample}/{sample}.fasta",
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
    params:
        is_amp=lambda wildcards: is_amplicon_data(wildcards.sample),
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
