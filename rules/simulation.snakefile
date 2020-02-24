rule create_basecall_error_model:
    input:
        bam='{basedir}/aligned_data/{sample_name}.real.transcriptome.bam',
    output:
        model='{basedir}/simulated_data/{sample_name}_model.json.gz'
    threads:
        config['yanosim_parameters'].get('threads', 24)
    conda:
        'env_yamls/yanosim.yml'
    shell:
        '''
        yanosim model \
          -p {threads} \
          -b {input.bam} \
          -o {output.model}
        '''


rule quantify_reads_for_simulation:
    input:
        bam='{basesdir}/aligned_data/{sample_name}.real.transcriptome.bam',
    output:
        quant='{basesdir}/simulated_data/{sample_name}_quant.tsv',
        gtf='{basesdir}/simulated_data/{sample_name}_simulated_reference.gtf'
    params:
        gtf=config['annot_gtf'],
        r_flag='' if not config['is_ensembl'] else '-r'
    conda:
        'env_yamls/yanosim.yml'
    shell:
        '''
        yanosim quantify \
          {params.r_flag} \
          -b {input.bam} \
          -o {output.quant} \
          -g {params.gtf} \
          -f {output.gtf}
        '''


def get_sim_params(wc):
    assert wc.seqtype in ['sim', 'sim_nofrag']
    if wc.seqtype == 'sim':
        params = '--model-frag'
    else:
        params = '--no-model-frag'

    seed = config['yanosim_parameters'].get('random_seed', None)
    if seed is not None:
        params += f' --seed {seed:d}'
    return params


rule simulate_reads:
    input:
        model='{basesdir}/simulated_data/{sample_name}_model.json.gz',
        quant='{basesdir}/simulated_data/{sample_name}_quant.tsv',
        fasta=config['transcriptome_fasta_fn'],
    output:
        fasta='{basesdir}/simulated_data/{sample_name}.{seqtype}.fasta'
    threads:
        config['yanosim_parameters'].get('threads', 24)
    params:
        sim_params=get_sim_params,
    conda:
        'env_yamls/yanosim.yml'
    shell:
        '''
        yanosim simulate -p {threads} {params.sim_params} \
          -f {input.fasta} \
          -m {input.model} \
          -q {input.quant} \
          -o {output.fasta}
        '''
