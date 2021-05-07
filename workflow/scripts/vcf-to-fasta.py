import re
import pysam
import numpy as np

IUPAC = {
    frozenset("AG"): "R",
    frozenset("CT"): "Y",
    frozenset("GC"): "S",
    frozenset("AT"): "W",
    frozenset("GT"): "K",
    frozenset("AC"): "M",
    frozenset("CGT"): "B",
    frozenset("AGT"): "D",
    frozenset("ACT"): "H",
    frozenset("ACG"): "V",
    frozenset("ACTG"): "N",
}


def phred_to_prob(phred):
    return 10 ** (-phred / 10)


with pysam.FastaFile(snakemake.input.fasta, "r") as infasta, pysam.VariantFile(
    snakemake.input.bcf, "rb"
) as invcf, pysam.AlignmentFile(snakemake.input.bam, "rb") as inbam:

    assert len(infasta.references) == 1, "expected reference with single contig"
    contig = infasta.references[0]
    ref_seq = infasta.fetch(contig)
    cov_a, cov_c, cov_g, cov_t = inbam.count_coverage(contig)
    coverage = np.add(np.add(np.add(cov_a, cov_c), cov_g), cov_t)

    seq = ""
    last_pos = -1  # last considered reference position
    for record in invcf:
        chunk_seq = ref_seq[last_pos + 1 : record.pos]

        # check for low coverage regions
        chunk_low_cov = (
            coverage[last_pos + 1 : record.pos] < snakemake.params.min_coverage
        )

        # mask low coverage regions
        chunk_seq[[chunk_low_cov]] = "N"

        seq += chunk_seq

        prob_high = phred_to_prob(record.info["PROB_CLONAL"]) + phred_to_prob(
            record.info["PROB_SUBCLONAL_HIGH"]
        )
        prob_major = phred_to_prob(record.info["PROB_SUBCLONAL_MAJOR"])

        apply = prob_high >= snakemake.params.min_prob_apply
        uncertain = (
            prob_major >= snakemake.params.min_prob_apply
            or (prob_high + prob_major) >= 0.5
            or record.format["DP"] < snakemake.params.min_coverage
        )
        if not (apply or uncertain):
            # we simply ignore this record
            continue

        assert len(record.alleles) == 2
        ref_allele, alt_allele = record.alleles

        # REF: A, ALT: <DEL>

        def handle_deletion(del_len):
            if not apply:
                seq += "N" * del_len
            last_pos += del_len + 1

        if alt_allele == "<DEL>":
            seq += ref_allele
            del_len = record.info["SVLEN"]
            handle_deletion(del_len)
        elif alt_allele == "<DUP>":
            dup_seq = ref_seq[record.pos : record.info["END"]]
            seq += dup_seq * 2
            last_pos += len(dup_seq)
        elif re.match("[A-Z]+$", alt_allele) is not None:
            # TODO cover more variant types before publication
            raise ValueError(f"Unexpected alt allele: {alt_allele} not yet supported")
        elif len(ref_allele) == len(alt_allele):
            # SNV or MNV
            if apply:
                seq += alt_allele
            else:
                # store IUPAC codes
                for a, b in zip(*record.alleles):
                    seq += IUPAC[frozenset((a.upper(), b.upper()))]
            last_pos += len(alt_allele)
        elif len(ref_allele) > 1 and len(alt_allele) == 1:
            # deletion
            del_len = len(ref_allele) - 1
            seq += alt_allele
            handle_deletion(del_len)
        elif len(ref_allele) == 1 and len(alt_allele) > 1:
            # insertion
            ins_seq = alt_allele[1:]
            seq += ref_allele
            if apply:
                seq += ins_seq
            else:
                seq += "N" * len(ins_seq)
            last_pos += 1
        else:
            raise ValueError(f"Unexpected alleles: {ref_allele}, {alt_allele}")

    # add sequence until end
    seq += ref_seq[last_pos:]


with open(snakemake.output[0], "w") as outfasta:
    print(f">{contig}", file=outfasta)
    print(seq, file=outfasta)
