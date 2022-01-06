# Copyright 2021 Thomas Battenfeld, Alexander Thomas, Johannes Köster.
# Licensed under the BSD 2-Clause License (https://opensource.org/licenses/BSD-2-Clause)
# This file may not be copied, modified, or distributed
# except according to those terms.

import re
import sys

sys.stderr = open(snakemake.log[0], "w")
# sys.stdout = open(snakemake.log[0], "a")

import gffutils
import numpy as np
import pandas as pd
import pysam


def phred_to_prob(phred):
    if phred is None:
        return 0
    return 10 ** (-phred / 10)


def has_numbers(inputString):
    return any(char.isdigit() for char in inputString)


variants_df = pd.DataFrame()
lineage_df = pd.DataFrame()

# read generated variant file and extract all variants
with pysam.VariantFile(snakemake.input.variant_file, "rb") as infile:
    for record in infile:
        if "SIGNATURES" in record.info:
            signatures = record.info.get("SIGNATURES", ("#ERROR0",))
            vaf = record.samples[0]["AF"][0]
            prob_not_present = phred_to_prob(
                record.info["PROB_ABSENT"][0]
            ) + phred_to_prob(record.info["PROB_ARTIFACT"][0])
            lineages = record.info["LINEAGES"]
            for signature in signatures:
                # generate df with all signatures + VAF and Prob_not_present from calculation
                variants_df = variants_df.append(
                    {
                        "Variant": signature,
                        "Frequency": vaf,
                        "Prob_not_present": prob_not_present,
                    },
                    ignore_index=True,
                )
                # generate df with lineage matrix for all signatures
                lineage_df = lineage_df.append(
                    {
                        "Variant": signature,
                        **{lineage.replace(".", " "): "x" for lineage in lineages},
                    },
                    ignore_index=True,
                )

# count occurences of signatures (x) in lineage columns and get sorted list
lineage_dict = dict(lineage_df.count())
lineage_dict = dict(
    sorted(lineage_dict.items(), key=lambda item: item[1], reverse=True)
)
top5_lineages = list(lineage_dict.keys())

# only include variant names (index=0) + top 5 variants (index=1-6) and reorder
lineage_df.drop(labels=top5_lineages[7:], axis=1, inplace=True)
lineage_df = lineage_df[top5_lineages[:7]]

# aggregate both dataframes by summing up repeating rows for VAR (maximum=1) and multiply Prob_not_present
variants_df = (
    variants_df.groupby(["Variant"])
    .agg(
        func={"Frequency": lambda x: min(sum(x), 1.0), "Prob_not_present": np.prod},
        axis=1,
    )
    .reset_index()
)

# new column for 1-prob_not_present = prob_present
variants_df["Probability"] = 1.0 - variants_df["Prob_not_present"]
variants_df["Prob X VAF"] = variants_df["Probability"] * variants_df["Frequency"]
lineage_df = lineage_df.drop_duplicates()

# calculate Jaccard coefficient for top 5 lineages and save row as df to append after sorting
jaccard_coefficient = {}
for lineage in range(1, len(top5_lineages[:6])):
    jaccard_coefficient[top5_lineages[lineage]] = round(
        variants_df[
            variants_df["Variant"].isin(
                lineage_df[lineage_df[top5_lineages[lineage]] == "x"]["Variant"]
            )
        ]["Prob X VAF"].sum()
        / variants_df["Prob X VAF"].sum(),
        3,
    )
jaccard_row = pd.DataFrame({"Variant": "Similarity", **jaccard_coefficient}, index=[0])

# merge variants dataframe and lineage dataframe
variants_df = variants_df.merge(lineage_df, left_on="Variant", right_on="Variant")

# add feature column for sorting
variants_df["Features"] = variants_df["Variant"].str.extract(r"(.+)[:].+|\*")

# position of variant for sorting and change type
variants_df["Position"] = variants_df["Variant"].str.extract(
    r"(.*:?[A-Z]+|\*$|-)([0-9]+)([A-Z]+$|\*$|-)$"
)[1]
variants_df = variants_df.astype({"Position": "int64"})

# generate sorting list from .gff with correct order of features
gff = gffutils.create_db(snakemake.input.annotation, dbfn=":memory:")
gene_start = {gene["gene_name"][0]: gene.start for gene in gff.features_of_type("gene")}
sorter = [k[0] for k in sorted(gene_start.items(), key=lambda item: item[1])]
sorterIndex = dict(zip(sorter, range(len(sorter))))
variants_df["Features_Rank"] = variants_df["Features"].map(sorterIndex)

# define categories for sorting
variants_df.loc[
    (variants_df[top5_lineages[1]] == "x") & (variants_df["Probability"] >= 0.95),
    "Order",
] = 0
variants_df.loc[
    (variants_df[top5_lineages[1]] == "x") & (variants_df["Probability"] <= 0.05),
    "Order",
] = 1
variants_df.loc[
    (variants_df[top5_lineages[1]] != "x") & (variants_df["Probability"] >= 0.95),
    "Order",
] = 2
variants_df.loc[
    (variants_df[top5_lineages[1]] == "x")
    & ((variants_df["Probability"] > 0.05) & (variants_df["Probability"] < 0.95)),
    "Order",
] = 3
variants_df.loc[
    (variants_df[top5_lineages[1]] != "x") & (variants_df["Probability"] <= 0.05),
    "Order",
] = 4
variants_df.loc[
    (variants_df[top5_lineages[1]] != "x")
    & ((variants_df["Probability"] > 0.05) & (variants_df["Probability"] < 0.95)),
    "Order",
] = 5

top5_lineages_row_df = pd.DataFrame(
    {"Variant": "Lineage", **{x: x for x in top5_lineages[1:6]}}, index=[0]
)

# sort final DF
variants_df["Prob X VAF"].replace([0, 0.0], np.NaN, inplace=True)
variants_df.sort_values(
    by=["Order", "Features_Rank", "Position"],
    ascending=[True, True, True],
    na_position="last",
    inplace=True,
)

# concat row with Jaccard coefficient, drop unneccesary columns, sort with Jaccard coefficient, round
variants_df = pd.concat([jaccard_row, variants_df]).reset_index(drop=True)
variants_df = pd.concat([top5_lineages_row_df, variants_df]).reset_index(drop=True)
variants_df = variants_df[["Variant", "Probability", "Frequency", *top5_lineages[1:6]]]
variants_df = variants_df.round({"Probability": 5, "Frequency": 5})
variants_df.set_index("Variant", inplace=True)
variants_df.sort_values(
    by="Similarity", axis=1, na_position="first", ascending=False, inplace=True
)
# rename top 5 hits
variants_df.rename(
    columns={
        x: y
        for x, y in zip(
            list(variants_df.columns)[2:],
            ["Highest similarity", "2nd", "3rd", "4th", "5th"],
        )
    },
    errors="raise",
    inplace=True,
)
# output variant_df
variants_df.to_csv(snakemake.output.variant_table, index=True, sep=",")
