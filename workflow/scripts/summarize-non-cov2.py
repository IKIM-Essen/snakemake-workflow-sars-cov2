sys.stderr = open(snakemake.log[0], "w")

import pandas as pd


def analyize_pangolin(sm_input):
    temp_dict = {}
    for pango_csv_path in sm_input.pangolin:
        sample = (
            pango_csv_path.replace("results/test-cases/tables/strain-calls/", "")
            .replace(".strains.pangolin.csv", "")
            .replace("non-cov2-", "")
        )
        with open(pango_csv_path, "r") as pango_file:
            pango_df = pd.read_csv(pango_file)
            if pango_df.loc[0, "note"] == "seq_len:1":
                temp_dict[sample] = "assembly failed"
            elif pango_df.loc[0, "status"] == "fail":
                temp_dict[sample] = "is non-sars-cov-2"
            elif (
                pango_df.loc[0, "status"] == "pass"
                and pango_df.loc[0, "lineage"] == "None"
            ):
                temp_dict[sample] = "is non-sars-cov-2"
            else:
                temp_dict[sample] = "is sars-cov-2"
    return temp_dict


def analyize_kallisto(sm_input):
    temp_dict = {}
    for kallisto_csv_path in sm_input.kallisto:
        sample = (
            kallisto_csv_path.replace("results/test-cases/tables/strain-calls/", "")
            .replace(".strains.kallisto.tsv", "")
            .replace("non-cov2-", "")
        )
        with open(kallisto_csv_path, "r") as kallisto_file:
            kallisto_df = pd.read_csv(kallisto_file, delimiter="\t")
            if kallisto_df.loc[0, "target_id"] == "other":
                temp_dict[sample] = "is non-sars-cov-2"
            else:
                temp_dict[sample] = "is sars-cov-2"
    return temp_dict


def aggregate_and_save(pangolin_summary, kallisto_summary, sm_output):
    agg_df = pd.DataFrame(
        [pangolin_summary, kallisto_summary], index=["pangolin", "kallisto"]
    ).T
    agg_df.index.name = "non-cov-2-sample"
    agg_df.to_csv(sm_output, sep="\t")


sm_input = snakemake.input
sm_output = snakemake.output[0]

pangolin_summary = analyize_pangolin(sm_input)
kallisto_summary = analyize_kallisto(sm_input)
aggregate_and_save(pangolin_summary, kallisto_summary, sm_output)
