# source: https://cbg-ethz.github.io/V-pipe/tutorial/sars-cov2/


rule download_v_pipe:
    output:
        snakefile="resources/benchmarking/v-pipe/vpipe.snake",
        ini="resources/benchmarking/v-pipe/init_project.sh",
    log:
        "logs/download_v_pipe.log",
    conda:
        "../../envs/git.yaml"
    params:
        repo=lambda w, output: os.path.dirname(output[0]),
    shell:
        "if [ -d '{params.repo}' ]; then rm -Rf {params.repo}; fi &&"
        "git clone --depth 1 --branch sars-cov2 https://github.com/thomasbtf/V-pipe.git {params.repo} 2> {log}"


rule v_pipe_init_project:
    input:
        "resources/benchmarking/v-pipe/init_project.sh",
    output:
        "results/benchmarking/v-pipe/{sample}/vpipe",
    log:
        "logs/v_pipe_init_project/{sample}.log",
    conda:
        "../../envs/unix.yaml"
    params:
        init_path=lambda w, input: os.path.join(os.getcwd(), input[0]),
        sample_dir=lambda w, output: os.path.dirname(output[0]),
    shell:
        "(mkdir -p {params.sample_dir} &&"
        " cd {params.sample_dir} &&"
        " bash {params.init_path})"
        "> {log} 2<&1"


rule v_pipe_setup_samples:
    input:
        fastqs=get_fastqs,
    output:
        fqs=expand(
            "results/benchmarking/v-pipe/{{sample}}/samples/{{sample}}/20200102/raw_data/{{sample}}_R{read}.fastq",
            read=[1, 2],
        ),
    log:
        "logs/v_pipe_setup_samples/{sample}.log",
    conda:
        "../../envs/v-pipe.yaml"
    params:
        fq_dir=lambda w, output: os.path.dirname(output[0]),
    shell:
        "(mkdir -p {params.fq_dir} &&"
        " gzip -dk {input.fastqs[0]} -c > {output.fqs[0]} &&"
        " gzip -dk {input.fastqs[1]} -c > {output.fqs[1]})"
        " 2> {log}"


rule v_pipe_dry_run:
    input:
        fastqs=expand(
            "results/benchmarking/v-pipe/{{sample}}/samples/{{sample}}/20200102/raw_data/{{sample}}_R{read}.fastq",
            read=[1, 2],
        ),
        vpipe="results/benchmarking/v-pipe/{sample}/vpipe",
    output:
        sample_sheet="results/benchmarking/v-pipe/{sample}/samples.tsv",
    log:
        "logs/v_pipe_dry_run/{sample}.log",
    conda:
        "../../envs/v-pipe.yaml"
    params:
        workdir=lambda w, input: os.path.dirname(input.vpipe),
    resources:
        external_pipeline=1,
        vpipe=1,
    shell:
        "(cd {params.workdir} &&"
        " ./vpipe --dryrun --nolock)"
        "> {log} 2>&1"


rule v_pipe_update_sample_sheet:
    input:
        "results/benchmarking/v-pipe/{sample}/samples.tsv",
    output:
        touch("results/benchmarking/v-pipe/.edited-sample/{sample}.log"),
    log:
        "logs/v_pipe_update_sample_sheet/{sample}.log",
    conda:
        "../../envs/v-pipe.yaml"
    shell:
        "sed -i 's/$/\t150/' {input} 2> {log}"


rule v_pipe_run:
    input:
        updated_sample_sheet="results/benchmarking/v-pipe/.edited-sample/{sample}.log",
        vpipe="results/benchmarking/v-pipe/{sample}/vpipe",
    output:
        vcf="results/benchmarking/v-pipe/{sample}/samples/{sample}/20200102/variants/SNVs/snvs.vcf",
        consensus="results/benchmarking/v-pipe/{sample}/samples/{sample}/20200102/references/ref_majority.fasta",
    log:
        "logs/v_pipe_run/{sample}.log",
    conda:
        "../../envs/v-pipe.yaml"
    benchmark:
        "benchmarks/v_pipe/{sample}.benchmark.txt"
    threads: 4
    resources:
        external_pipeline=1,
        vpipe=1,
    params:
        workdir=lambda w, input: os.path.dirname(input.vpipe),
    shell:
        "(cd {params.workdir} &&"
        " ./vpipe --cores {threads} -p -F --nolock)"
        "> {log} 2>&1"


rule v_pipe_fix_vcf:
    input:
        "results/benchmarking/v-pipe/{sample}/samples/{sample}/20200102/variants/SNVs/snvs.vcf",
    output:
        "results/benchmarking/v-pipe/fixed-vcf/{sample}.vcf",
    log:
        "logs/v_pipe_fix_vcf/{sample}.log",
    conda:
        "../../envs/python.yaml"
    script:
        "../../scripts/v_pipe_fix_vcf.py"


rule v_pipe_rmv_dir:
    input:
        "results/benchmarking/v-pipe/fixed-vcf/{sample}.vcf",
    output:
        touch("results/benchmarking/v-pipe/.delted-dir/{sample}.log"),
    log:
        "logs/v_pipe_rmv_dir/{sample}.log",
    conda:
        "../../envs/unix.yaml"
    params:
        outdir="results/benchmarking/v-pipe/{sample}",
    shell:
        "rm -rf {params.outdir} 2> {log}"
