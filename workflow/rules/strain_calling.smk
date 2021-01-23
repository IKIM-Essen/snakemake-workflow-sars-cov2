rule cat_covid_genomes:
    input:
        # TODO how to not use the string "resources/strain-accessions.txt"? Problematic if .txt is not ava. from start
        genomes = expand("resources/covid-genomes/{accession}.fasta", accession=get_strain_accessions_from_txt("resources/strain-accessions.txt"))
    output:
        "resources/covid-genomes.fasta"
    threads: 4
    shell:
        "cat {input.genomes} > {output}"


# NOT needed, if rule sourmash_compute_samples takes two fast qs
rule cat_trimmed_samples:
    input:
        expand("results/trimmed/{{sample}}.{read}.fastq.gz", read=[1, 2])
    output:
        "results/trimmed/{sample}.both.fastq.gz"
    shell:
        "cat {input} > {output}"


rule sourmash_compute_covid_genomes:
    input:
        "resources/covid-genomes.fasta", # All downloaded genomes (see common.smk -> limitation of covid genomes to download)
        # "resources/genomic.fna", # Static data from NCBI datasets downloader
        # "resources/covid-genomes/genome.fasta" # Wuhan genome
    output:
        "resources/sourmash/covid-genomes.sig",
    log:
        "logs/sourmash/sourmash-compute.log",
    threads: 4
    params:
        k="31",
        scaled="1000",
        extra="", # --singleton flag needed here?
    wrapper:
        "v0.69.0/bio/sourmash/compute"

# TODO Adjust for 2 fastqs, singleton flag?
rule sourmash_compute_samples:
    input:
        "results/trimmed/{sample}.both.fastq.gz"
    output:
        "resources/sourmash/{sample}.sig",
    log:
        "logs/sourmash/sourmash-compute-{sample}.log",
    threads: 4
    params:
        k="31",
        scaled="1000",
        extra="",
    wrapper:
        "v0.69.0/bio/sourmash/compute"

# makes .sig from whole all single covid genomes .fasta
rule sourmash_compute_covids:
    input:
        "resources/covid-genomes/{accession}.fasta"
    output:
        "resources/covid-genomes/{accession}.sig",
    log:
        "logs/sourmash/sourmash-compute-acc-{accession}.log",
    threads: 4
    params:
        k="31",
        scaled="1000",
        extra="",
    wrapper:
        "v0.69.0/bio/sourmash/compute"


# db for smash search
rule smash_index:
    input:
        genomes = expand("resources/covid-genomes/{accession}.sig", accession=get_strain_accessions_from_txt("resources/strain-accessions.txt")),
    output:
        "resources/sourmash/covid-db.sbt.json"
    conda:
        "../envs/sourmash.yaml"
    shell:
        "sourmash index -k 31 {output} {input.genomes}"


rule sourmash_search:
    input:
        read = "resources/sourmash/{sample}.sig",
        db = "resources/sourmash/covid-db.sbt.json"
    output:
        "results/sourmash/search-{sample}.csv"
    conda:
        "../envs/sourmash.yaml"
    shell:
        "sourmash search {input.read} {input.db} -o {output} --threshold 0.001 --containment"


rule sourmash_gather:
    input:
        read = "resources/sourmash/{sample}.sig",
        metagenome = "resources/sourmash/covid-genomes.sig"
    output:
        "results/sourmash/gather-{sample}.csv"
    log:
        "logs/sourmash/gather-{sample}.log"
    conda:
        "../envs/sourmash.yaml"
    shell:
        "(sourmash gather -k 31 {input.read} {input.metagenome} -o {output} --threshold-bp 1000) 2> {log}"

# TODO
# 1. at compute handover of two fastq files, dont use cat_trimmed_samples
# 2. the entrez rule get_genome also downloads partial reads of covid genomes (e.g. MW368461) or empty genome files (e.g. MW454604). Add rule to exiculde those rules "faulty" covid genomes
# 3. Fix get_strain_accessions_from_txt - txt file must be in folder before staring the workflow -> questionable
# 3. clean up logging / add propper logging
# 4. if ok, then gather with folkers data
# 5. filter low abundnce
# 6. parameter adjustment
# https://sourmash.readthedocs.io/en/latest/using-sourmash-a-guide.html#computing-signatures-for-read-files