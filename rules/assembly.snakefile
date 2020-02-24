rule run_stringtie:
    input:
        bam='{basedir}/aligned_data/{sample_name}.{seqtype}.{bam_type}.bam',
    output:
        gtf='{basedir}/assemblies/{sample_name}.{seqtype}.{bam_type}.gtf'
    threads:
        config['stringtie_parameters'].get('threads', 24)
    conda:
        'env_yamls/stringtie.yml'
    shell:
        '''
        stringtie -L -o {output.gtf} {input.bam}
        '''


def get_ground_truth_gtf(wc):
    if wc.seqtype == 'real':
        return config['annot_gtf']
    else:
        return '{basedir}/simulated_data/{sample_name}_simulated_reference.gtf'


rule assess_stringtie_performance:
    input:
        test_gtf='{basedir}/assemblies/{sample_name}.{seqtype}.{bam_type}.gtf',
        ref_gtf=get_ground_truth_gtf,
    output:
        stats='{basedir}/assemblies/{sample_name}.{seqtype}.{bam_type}.stats'
    conda:
        'env_yamls/stringtie.yml'
    shell:
        '''
        gffcompare -T -o {output.stats} -r {input.ref_gtf} {input.test_gtf}
        '''