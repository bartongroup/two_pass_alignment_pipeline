import re
from collections import defaultdict, Counter
import numpy as np
import click

def exons_to_introns(exon_invs):
    if len(exon_invs) == 1:
        return np.array([])
    else:
        return np.stack([exon_invs[:-1, 1], exon_invs[1:, 0]], axis=1)


def parse_exons(record):
    start = int(record[1])
    end = int(record[2])
    exstarts = np.fromstring(record[11], sep=',', dtype=int) + start
    exends = exstarts + np.fromstring(record[10], sep=',', dtype=int)
    exons = np.dstack([exstarts, exends])[0]
    return exons


def get_bed12_linked_splicing(bed_fn):
    linked_splices = defaultdict(set)
    with open(bed_fn) as bed:
        for record in bed:
            record = record.split()
            chrom = record[0]
            strand = record[5]
            read_id = record[3]
            exons = parse_exons(record)
            introns = exons_to_introns(exons)
            for inv in introns:
                linked_splices[read_id].add(f'{chrom}:{inv[0]}-{inv[1]}({strand})')
    return linked_splices


def get_gtf_transcript_id(attrs):
    return re.search('transcript_id \"(.*?)\";', attrs).group(1)


def get_gtf_exons(gtf_fn):
    with open(gtf_fn) as gtf:
        for record in gtf:
            if record.startswith('#'):
                continue
            record = record.strip().split('\t')
            if record[2] == 'exon':
                transcript_id = get_gtf_transcript_id(record[8])
                yield record[0], int(record[3]) - 1, int(record[4]), transcript_id, record[6]


def parse_gtf_exon_invs(gtf_fn):
    transcript_clusters = defaultdict(list)
    for chrom, start, end, transcript_id, strand in get_gtf_exons(gtf_fn):
        transcript_clusters[(transcript_id, chrom, strand)].append((start, end))
    for (transcript_id, chrom, strand), exons in transcript_clusters.items():
        exons.sort()
        yield transcript_id, chrom, strand, np.array(exons)


def get_gtf_linked_splicing(gtf_fn):
    linked_splices = defaultdict(set)
    for transcript_id, chrom, strand, exons in parse_gtf_exon_invs(gtf_fn):
        introns = exons_to_introns(exons)
        for inv in introns:
            linked_splices[transcript_id].add(f'{chrom}:{inv[0]}-{inv[1]}({strand})')
    return linked_splices


def score_sim_alignment(aln_bed_fn, reference_splices, remove_version=False):
    ref_splice_inv = {frozenset(v): k for k, v in reference_splices.items()}
    aln_splices = get_bed12_linked_splicing(aln_bed_fn)
    res = {}
    quant_res = Counter()
    for read_id, splice in aln_splices.items():
        splice = frozenset(splice)
        transcript_of_origin = re.search('^(.+)_sim\d+', read_id).group(1)
        if remove_version:
            # for ENSEMBL the transcriptome fasta
            # (and therefore the read id)
            # has the version in the transcript id
            # in the header (format TRANSCRIPT_ID.VERSION)
            # whereas the gtf does not
            transcript_of_origin = transcript_of_origin.split('.')[0]
        correct_splicing = reference_splices[transcript_of_origin]
        if splice == correct_splicing:
            res[read_id] = 1 # splice is correct
            quant_res[transcript_of_origin] += 1
        elif not len(splice):
            res[read_id] = 0 # read is incorrectly unspliced
            # don't add to any transcript
        elif splice in ref_splice_inv:
            res[read_id] = 2 # read maps to incorrect transcript
            quant_res[ref_splice_inv[splice]] += 1
        else:
            res[read_id] = 0 # read is incorrectly spliced
            # no annotated transcript to add to
    return res, quant_res


@click.command()
@click.option('-b', '--bed12-fn')
@click.option('-g', '--annot-gtf-fn')
@click.option('-o', '--output-fn')
@click.option('-q', '--output-quant-fn')
@click.option('-r', '--remove-ensembl-transcript-version', default=False, is_flag=True)
def main(bed12_fn, annot_gtf_fn, output_fn, output_quant_fn, remove_ensembl_transcript_version):
    reference_splices = get_gtf_linked_splicing(annot_gtf_fn)
    res, quant_res = score_sim_alignment(bed12_fn, reference_splices, remove_ensembl_transcript_version)
    with open(output_fn, 'w') as f:
        for read_id, classi in res.items():
            f.write(f'{read_id}\t{classi}\n')

    with open(output_quant_fn, 'w') as q:
        for transcript_id, count in quant_res.items():
            q.write(f'{transcript_id}\t{count}\n')


if __name__ == '__main__':
    main()