import sys
import re
from collections import Counter


def get_read_counts(sim_reads_fn):
    counts = Counter()
    with open(sim_reads_fn) as f:
        for line in f:
            if line.startswith('>'):
                transcript_id = re.match('^>(.+)_sim\d+$', line).group(1)
                counts[transcript_id] += 1
    return counts


def filter_gtf(gtf_fn, output_gtf_fn, counts):
    all_transcripts = set()
    counts_with_zero_counts = {}
    with open(gtf_fn) as g, open(output_gtf_fn, 'w') as f:
        for record in g:
            try:
                transcript_id = re.search('transcript_id "(.*?)";', record).group(1)
            except AttributeError:
                continue
            if transcript_id in counts:
                f.write(record)
                counts_with_zero_counts[transcript_id] = counts[transcript_id]
            else:
                counts_with_zero_counts[transcript_id] = 0
    return counts_with_zero_counts


if __name__ == '__main__':
    sim_reads_fn = sys.argv[1]
    quant_fn = sys.argv[2]
    gtf_fn = sys.argv[3]
    output_gtf_fn = sys.argv[4]
    counts = get_read_counts(sim_reads_fn)
    counts = filter_gtf(gtf_fn, output_gtf_fn, counts)
    with open(quant_fn, 'w') as f:
        for transcript_id, c in counts.items():
            f.write('{tid}\t{c}\n'.format(tid=transcript_id, c=c))