def get_sequence_input(wc):
    fastq_fns = config['fastq_fns']
    if wc.seqtype == 'real':
        return fastq_fns[wc.sample_name]
    else:
        return f'{wc.basedir}/simulated_data/{wc.sample_name}.{wc.seqtype}.fasta'
        

def get_junc_bed_fn(wc):
    bamtypes = [
        'firstpass', 'nofilt',
        'refguided',
        'dt1filt', 'dt2filt',
        'dt2filt_merged',
        'transcriptome'
    ]
    assert wc.bamtype in bamtypes

    if wc.bamtype == 'firstpass' or wc.bamtype == 'transcriptome':
        return []
    elif wc.bamtype == 'refguided':
        return 'juncs/annot_juncs.bed'
    elif wc.bamtype == 'dt2filt_merged':
        return f'juncs/merged.{wc.seqtype}.dt2filt.bed'
    else:
        return f'{wc.basedir}/juncs/{wc.sample_name}.{wc.seqtype}.{wc.bamtype}.bed'


def get_reference_fn(wc):
    if wc.bamtype == 'transcriptome':
        return config['transcriptome_fasta_fn']
    else:
        return config['genome_fasta_fn']


def minimap2_general_parameters(wc):
    params = ['-a', '-L', '--cs=long']
    sequencing_type = config['sequencing_type']
    assert sequencing_type in ['drs', 'cdna', 'isoseq']
    if wc.bamtype == 'transcriptome':
        if sequencing_type == 'drs':
            params += ['-k14', '--for-only']
        else:
            params += ['-k15']
    else:
        intron_size = config['minimap2_parameters'].get(
            'max_intron_size', 200_000
        )
        params += ['-w5', '--splice',
                   '-g2000', f'-G{intron_size}',
                   '-A1', '-B2', '-O2,32', '-E1,0', '-C9',
                   '--splice-flank=yes', '-z200']
        if sequencing_type == 'drs':
            params += ['-k14', '-uf']
        else:
            params += ['-k15', '-ub']
    return ' '.join(params)


def minimap2_junc_parameters(wc):
    if wc.bamtype in ('firstpass', 'transcriptome'):
        return ''
    else:
        intron_bed = get_junc_bed_fn(wc)
        junc_bonus = config['minimap2_parameters'].get(
            'junction_bonus', 12
        )
        params = f'--junc-bed {intron_bed} --junc-bonus={junc_bonus}'
        return params


rule annot_to_juncs:
    input:
        config['annot_gtf']
    output:
        'juncs/annot_juncs.bed'
    conda:
        'env_yamls/minimap2.yml'
    shell:
        '''
        paftools.js gff2bed -j {input} |
        awk -v OFS='\t' '{{print $1, $2, $3, "intron", $5, $6}}' |
        sort -k1,1 -k2,2n | uniq > {output}
        '''

            
rule map_with_minimap:
    input:
        fastq=get_sequence_input,
        bed=get_junc_bed_fn,
        reference=get_reference_fn,
    output:
        '{basedir}/aligned_data/{sample_name}.{seqtype}.{bamtype}.bam'
    threads: 
        config['minimap2_parameters'].get('threads', 24)
    params:
        mm2_params=minimap2_general_parameters,
        junc_params=minimap2_junc_parameters,
    conda:
        'env_yamls/minimap2.yml'
    shell:
        '''
        minimap2 -t{threads} \
          {params.mm2_params} \
          {params.junc_params} \
          {input.reference} \
          {input.fastq} |
        samtools view -bS - |
        samtools sort -m 1G -@ {threads} -o - - > {output}
        samtools index {output}
        '''