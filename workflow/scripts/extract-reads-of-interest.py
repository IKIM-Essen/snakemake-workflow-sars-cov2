import pysam

sars_cov2_id = "NC_045512"

def is_sars_cov2(record, mate=False):
    if mate:
        return record.next_reference_name.startwith(sars_cov2_id)
    else:
        return record.reference_name.startswith(sars_cov2_id)

with pysam.AlignmentFile(snakemake.input[0], "rb") as inbam:
    with pysam.AlignmentFile(snakemake.output[0], "wb", template=inbam) as outbam:
        for record in inbam:
            if record.is_unmapped and record.is_mate_unmapped:
                outbam.write(record)
            elif (
                (is_sars_cov2(record) and record.is_mate_unmapped) or 
                (is_sars_cov2(record, mate=True) and record.is_unmapped) or 
                (is_sars_cov2(record) and is_sars_cov2(record, mate=True))
            ):
                outbam.write(record)