import re


rule flair_correct:
    input:
        bed='{basedir}/bed12/{sample_name}.{seqtype}.{bamtype}.bed',
        reference=config['genome_fasta_fn'],
        chromsizes=config['chromsizes_fn'],
        annot_juncs='juncs/annot_juncs.bed'
    output:
        bed='{basedir}/flair/{sample_name}.{seqtype}.{bamtype}.corrected.bed',
    params:
        output_prefix=lambda wc, output: re.sub('.corrected.bed$', '', output.bed)
    conda:
        'env_yamls/flair.yml'
    shell:
        '''
        flair.py correct \
          -q {input.bed} \
          -g {input.reference} \
          -c {input.chromsizes} \
          -j {input.annot_juncs} \
          -o {params.output_prefix}
        cat {params.output_prefix}_all_corrected.bed {params.output_prefix}_all_inconsistent.bed |
        sort -k1,1 -k2,2n > {output.bed}
        '''