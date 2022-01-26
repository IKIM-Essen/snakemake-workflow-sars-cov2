rule download_artic_primer_schemes:
    output:
        directory("resources/benchmarking/artic/repo"),
    log:
        "logs/download_artic_primer_schemes.log",
    conda:
        "../envs/git.yaml"
    shell:
        "git clone https://github.com/artic-network/artic-ncov2019.git {output} 2> {log}"


rule download_v_pipe:
    output:
        directory("resources/benchmarking/v-pipe/repo"),
    log:
        "logs/download_v_pipe.log",
    conda:
        "../envs/git.yaml"
    shell:
        "git clone --depth 1 --branch sars-cov2 https://github.com/cbg-ethz/V-pipe.git {output} 2> {log}"


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


rule download_ViReflow:
    output:
        "resources/benchmarking/ViReflow/ViReflow.py",
    log:
        "logs/download_ViReflow.log",
    conda:
        "../envs/unix.yaml"
    shell:
        "(wget 'https://raw.githubusercontent.com/niemasd/ViReflow/master/ViReflow.py' -O {output} &&"
        " chmod 755 {output})"
        " 2> {log}"


rule download_C_VIEW:
    output:
        "resources/benchmarking/C-VIEW/install.sh",
    log:
        "logs/download_C_VIEW.log",
    conda:
        "../envs/unix.yaml"
    shell:
        "(wget 'https://raw.githubusercontent.com/ucsd-ccbb/C-VIEW/main/install.sh' -O {output} &&"
        " chmod 755 {output})"
        " 2> {log}"
