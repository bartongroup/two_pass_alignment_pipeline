def get_2passtools_params(wc):
    twopass_config = config['2passtools_parameters']
    jad_size_thresh = twopass_config.get('jad_size_threshold', 4)
    local_dist = twopass_config.get('primary_junction_search_distance', 20)
    motifs = twopass_config.get('canonical_motifs', 'GTAG|GCAG|ATAG')
    winsize = twopass_config.get('sequence_model_window_size', 128)
    kfold = twopass_config.get('sequence_model_kfold', 6)
    low_conf = twopass_config.get('low_confidence_threshold', 0.1)
    high_conf = twopass_config.get('high_confidence_threshold', 0.6)
    params = (
        f'-j {jad_size_thresh} -d {local_dist} '
        f'-m "{motifs}" -w {winsize} -k {kfold} '
        f'-lt {low_conf} -ht {high_conf}'
    )
    return params


def get_2passtools_stranded(wc):
    if config['sequencing_type'] == 'drs':
        is_stranded = '--stranded'
    else:
        is_stranded = '--unstranded'
    return is_stranded


rule run_2passtools:
    input:
        bam='{basedir}/aligned_data/{sample_name}.{seqtype}.firstpass.bam',
        reference=config['genome_fasta_fn']
    output:
        bed='{basedir}/juncs/{sample_name}.{seqtype}.all.bed'
    params:
        two_pass_params=get_2passtools_params,
        is_stranded=get_2passtools_stranded
    threads:
        config['2passtools_parameters'].get('threads', 12)
    conda:
        'env_yamls/2passtools.yml'
    shell:
        '''
        2passtools score {params.two_pass_params} \
          {params.is_stranded} \
          -f {input.reference} \
          -o {output.bed} \
          {input.bam}
        '''


def get_merg_junc_input(wc):
    target_names, target_dirs = list(zip(*config['basedirs'].items()))
    bed_fns = expand(
        '{basedir}/juncs/{sample_name}.{{seqtype}}.all.bed',
        zip, basedir=target_dirs, sample_name=target_names
    )
    return bed_fns


rule merge_juncs:
    input:
        bams=get_merg_junc_input,
        reference=config['genome_fasta_fn']
    output:
        all='juncs/merged.{seqtype}.all.bed',
        filtered='juncs/merged.{seqtype}.dt2filt.bed',
    params:
        two_pass_params=get_2passtools_params,
    threads:
        config['2passtools_parameters'].get('threads', 12)
    conda:
        'env_yamls/2passtools.yml'
    shell:
        '''
        2passtools merge {params.two_pass_params} \
          -f {input.reference} \
          -o {output.all} \
          {input.bams}
        2passtools filter -o {output.filtered} {output.all}
        '''


def get_rule_for_filttype(wc):
    if wc.filttype == 'nofilt':
        # dummy filter on count cols
        return 'count > 0'
    elif wc.filttype == 'dt1filt':
        return 'decision_tree_1_pred'
    elif wc.filttype == 'dt2filt':
        return 'decision_tree_2_pred'
    else:
        raise ValueError(wc.filttype)


rule apply_junc_filter:
    input:
        bed='{basedir}/juncs/{sample_name}.{seqtype}.all.bed'
    output:
        bed='{basedir}/juncs/{sample_name}.{seqtype}.{filttype}.bed'
    params:
        junc_filter=get_rule_for_filttype
    conda:
        'env_yamls/2passtools.yml'
    shell:
        '''
        2passtools filter \
          --exprs '{params.junc_filter}' \
          -o {output.bed} \
          {input.bed}
        '''