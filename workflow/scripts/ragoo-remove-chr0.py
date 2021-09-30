'# Copyright 2021 Thomas Battenfeld, Alexander Thomas, Johannes Köster.'
'# Licensed under the BSD 2-Clause License (https://opensource.org/licenses/BSD-2-Clause)'
'# This file may not be copied, modified, or distributed'
'# except according to those terms.
'
import sys

sys.stderr = open(snakemake.log[0], "w")
sample = snakemake.wildcards.sample

from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from Bio.Seq import Seq


def remove_chr0(data_path, out_path):
    """This function removes the Chr0 contig generated by raGOO.
    It also renames the id in the FASTA file to the actual sample name.
    In the case where no pseudomolecule is constructed other than the Chr0, it ensures,
    that the FASTA fill contains a 'filler-contig' with a sequence of 'N'.

    Args:
        data_path (string): Path to raGOO output
        out_path (string): Path to store the filtered raGOO output
    """
    valid_records = []
    with open(data_path, "r") as handle:
        i = 1
        for record in SeqIO.parse(handle, "fasta"):
            if "Chr0" not in record.name:
                # rename id from "virus-reference-genome"_RaGOO to actual sample name
                record.id = sample + ".{}".format(i)
                valid_records.append(record)
                i += 1

    # if there was no contig except the Chr0 one
    # add a filler contig to the fasta file
    # in order avoid failing of the following tools
    if not valid_records:
        valid_records.append(
            SeqRecord(
                Seq("N"),
                id="filler-contig",
                name="filler-contig",
                description="filler-contig",
            )
        )
    SeqIO.write(valid_records, out_path, "fasta")


remove_chr0(snakemake.input[0], snakemake.output[0])
