def _expand_basedir_sample_name(file_pattern):
    target_names, target_dirs = list(zip(*config['basedirs'].items()))    
    expanded_file_pattern = expand(
        file_pattern,
        zip,
        basedir=target_dirs,
        sample_name=target_names
    )
    return expanded_file_pattern


def _expand_bamtype_seqtype(file_pattern, bam_types, incl_sim=True, incl_real=True):
    seq_types = []
    if incl_sim:
        run_sim = config['yanosim_parameters'].get('run_simulation', True)
        sim_frag = config['yanosim_parameters'].get('simulate_three_prime_bias', False)
        if run_sim:
            seq_types.append('sim' if sim_frag else 'sim_nofrag')
    if incl_real:
        seq_types.append('real')
    expanded_file_pattern = expand(
        file_pattern,
        bam_type=bam_types,
        seq_type=seq_types
    )
    return expanded_file_pattern


def bam_file_input(wc):
    bam_fns = _expand_basedir_sample_name(
        '{basedir}/aligned_data/{sample_name}.{{seq_type}}.{{bam_type}}.bam',
    )
    bam_fns = _expand_bamtype_seqtype(
        bam_fns, bam_types=['firstpass', 'nofilt',
                            'dt1filt', 'dt2filt',
                            'dt2filt_merged', 'refguided']
    )
    return bam_fns


def stringtie_input(wc):
    gtf_fns = _expand_basedir_sample_name(
        ['{basedir}/assemblies/{sample_name}.{{seq_type}}.{{bam_type}}.gtf',
         '{basedir}/assemblies/{sample_name}.{{seq_type}}.{{bam_type}}.stats'],
    )
    gtf_fns = _expand_bamtype_seqtype(
        gtf_fns, bam_types=['firstpass', 'nofilt',
                            'dt1filt', 'dt2filt',
                            'dt2filt_merged', 'refguided']
    )
    return gtf_fns


def junction_input(wc):
    bed_fns = _expand_basedir_sample_name(
        '{basedir}/juncs/{sample_name}.{{seq_type}}.{{bam_type}}.bed'
    )
    bed_fns = _expand_bamtype_seqtype(
        bed_fns, bam_types=['all', 'nofilt',
                            'dt1filt', 'dt2filt']
    )
    return bed_fns


def benchmark_input(wc):
    tsv_fns = _expand_basedir_sample_name(
        ['{basedir}/metrics/{sample_name}.{{seq_type}}.{{bam_type}}.tsv',
         '{basedir}/metrics/{sample_name}.{{seq_type}}.{{bam_type}}.quant.tsv']
    )
    tsv_fns = _expand_bamtype_seqtype(
        tsv_fns, bam_types=['firstpass', 'nofilt',
                            'dt1filt', 'dt2filt',
                            'dt2filt_merged',
                            'flair_corrected',
                            'refguided'],
        incl_real=False,
    )
    return tsv_fns