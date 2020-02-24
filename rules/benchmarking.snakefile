rule bam_to_bed12:
    input:
        bam='{basedir}/aligned_data/{sample_name}.{seqtype}.{bam_type}.bam',
    output:
        bed='{basedir}/bed12/{sample_name}.{seqtype}.{bam_type}.bed'
    conda:
        'env_yamls/bedtools.yml'
    shell:
        '''
        bedtools bamtobed -bed12 -i {input.bam} > {output.bed}
        '''

def assess_sim_alignment_input(wc):
    if wc.bam_type == 'flair_corrected':
        return '{basedir}/flair/{sample_name}.{seqtype}.firstpass.corrected.bed'
    else:
        return '{basedir}/bed12/{sample_name}.{seqtype}.{bam_type}.bed'


rule assess_sim_alignment:
    input:
        bed=assess_sim_alignment_input,
        annot=config['annot_gtf']
    output:
        tsv='{basedir}/metrics/{sample_name}.{seqtype}.{bam_type}.tsv',
        quant='{basedir}/metrics/{sample_name}.{seqtype}.{bam_type}.quant.tsv',
    params:
        r_flag='' if not config['is_ensembl'] else '-r'
    conda:
        'env_yamls/2passtools.yml'
    shell:
        '''
        python ../../scripts/score_simulated.py \
          {params.r_flag} \
          -b {input.bed} \
          -g {input.annot} \
          -o {output.tsv} \
          -q {output.quant}
        '''