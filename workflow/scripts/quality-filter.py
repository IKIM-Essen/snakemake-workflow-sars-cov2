# Copyright 2022 Thomas Battenfeld, Alexander Thomas, Johannes Köster.
# Licensed under the BSD 2-Clause License (https://opensource.org/licenses/BSD-2-Clause)
# This file may not be copied, modified, or distributed
# except according to those terms.

sys.stderr = open(snakemake.log[0], "w")
min_identity = snakemake.params.get("min_identity", 0.9)
max_n = snakemake.params.get("max_n", 0.05)

from os import path
from typing import List

import pandas as pd
import pysam


def get_identity(quast_report_paths: List[str]) -> dict:
    """Extracts genome fraction form quast reports

    Args:
        quast_report_paths (List[str]): List of paths to quast reports (tsv) to be parsed

    Returns:
        dict: Dict consisting of sample name and genome fractions
    """

    identity_dict = {}

    for report_path in quast_report_paths:
        # extract sample name
        sample = path.dirname(report_path).split("/")[-1]

        # load report
        report_df = pd.read_csv(report_path, delimiter="\t", names=["name", "value"])
        report_df.set_index("name", inplace=True)
        # select genome fraction (%)
        try:
            fraction = float(report_df.at["Genome fraction (%)", "value"]) / 100
        except:
            # no "Genome fraction (%)" in quast report. Case for not assemblable samples
            fraction = 0.0

        # store in dict
        identity_dict[sample] = fraction

    return identity_dict


def get_sequence(path: str):
    with pysam.FastxFile(path) as fh:
        for entry in fh:
            return entry.name.split(".")[0], entry.sequence


def get_n_share(contig_paths: List[str]) -> dict:
    """Extracts share of Ns in given contigs.

    Args:
        contig_paths (List[str]): List of paths of to be parsed contig

    Returns:
        dict: Dict consisting of sample name and share of Ns
    """

    n_share_dict = {}
    seq_dict = {}

    for contig_path in contig_paths:
        name, sequence = get_sequence(contig_path)
        assert isinstance(sequence, str), "More than one sequence in .fasta file."
        seq_dict[name] = sequence

    for key, value in seq_dict.items():
        n_share_dict[key] = value.count("N") / len(value)

    return n_share_dict


def filter_and_save(
    identity: dict,
    n_share: dict,
    min_identity: float,
    max_n: float,
    save_path: str,
    summary_path: str,
):
    """Filters and saves sample names

    Args:
        identity (dict): Dict consisting of sample name and genome fractions
        n_share (dict): Dict consisting of sample name and share of Ns
        min_identity (float): Min identity to virus reference genome of reconstructed genome
        max_n (float): Max share of N in the reconstructed genome
        save_path (str): Path to save the filtered sample to as .txt
        summary_path (str): Path to identity and n share to as .tsv
    """

    # aggregate all result into one df
    agg_df = pd.DataFrame({"identity": identity, "n_share": n_share})

    # print agg_df to stderr for logging
    print("Aggregated data of all samples", file=sys.stderr)
    print(agg_df, file=sys.stderr)
    agg_df.index.name = "Sample"
    agg_df.to_csv(summary_path, sep="\t")

    # filter this accordingly to the given params
    filtered_df = agg_df[
        (agg_df["identity"] > min_identity) & (agg_df["n_share"] < max_n)
    ]

    # print filtered to stderr for logging
    print("", file=sys.stderr)
    print("Filtered data", file=sys.stderr)
    print(filtered_df, file=sys.stderr)

    # print accepted samples to stderr for logging
    print("", file=sys.stderr)
    print("Accepted samples", file=sys.stderr)
    print(filtered_df.index.values, file=sys.stderr)

    # save accepted samples
    with open(save_path, "w") as snakemake_output:
        for sample in filtered_df.index.values:
            snakemake_output.write("%s\n" % sample)


identity_dict = get_identity(snakemake.input.quast)
n_share_dict = get_n_share(snakemake.input.contigs)
filter_and_save(
    identity_dict,
    n_share_dict,
    min_identity,
    max_n,
    snakemake.output.passed_filter,
    snakemake.output.filter_summary,
)
