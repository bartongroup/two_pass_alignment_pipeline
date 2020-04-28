set -euo pipefail

# REP 1
mkdir -p workman_Bham_Run1_20171009_directRNA/raw_data
curl https://zenodo.org/record/3773729/files/20191112_human_bham1.dna.fastq \
 > workman_Bham_Run1_20171009_directRNA/raw_data/20191112_human_bham1.dna.fastq
 
mkdir -p workman_Bham_Run1_20171009_directRNA/simulated_data
curl https://zenodo.org/record/3773729/files/20191112_human_bham1.sim_nofrag.fasta \
 > workman_Bham_Run1_20171009_directRNA/simulated_data/20191112_human_bham1.sim_nofrag.fasta

# REP 2
mkdir -p workman_Bham_Run2_20171011_directRNA/raw_data
curl https://zenodo.org/record/3773729/files/20191112_human_bham2.dna.fastq \
 > workman_Bham_Run2_20171011_directRNA/raw_data/20191112_human_bham2.dna.fastq
 
mkdir -p workman_Bham_Run2_20171011_directRNA/simulated_data
curl https://zenodo.org/record/3773729/files/20191112_human_bham2.sim_nofrag.fasta \
 > workman_Bham_Run2_20171011_directRNA/simulated_data/20191112_human_bham2.sim_nofrag.fasta
 
# REP 3
mkdir -p workman_Bham_Run3_20171011_directRNA/raw_data
curl https://zenodo.org/record/3773729/files/20191112_human_bham3.dna.fastq \
 > workman_Bham_Run3_20171011_directRNA/raw_data/20191112_human_bham3.dna.fastq
 
mkdir -p workman_Bham_Run3_20171011_directRNA/simulated_data
curl https://zenodo.org/record/3773729/files/20191112_human_bham3.sim_nofrag.fasta \
 > workman_Bham_Run3_20171011_directRNA/simulated_data/20191112_human_bham3.sim_nofrag.fasta

#REP 4
mkdir -p workman_Bham_Run5_20171011_directRNA/raw_data
curl https://zenodo.org/record/3773729/files/20191112_human_bham5.dna.fastq \
 > workman_Bham_Run5_20171011_directRNA/raw_data/20191112_human_bham5.dna.fastq
 
mkdir -p workman_Bham_Run5_20171011_directRNA/simulated_data
curl https://zenodo.org/record/3773729/files/20191112_human_bham5.sim_nofrag.fasta \
 > workman_Bham_Run5_20171011_directRNA/simulated_data/20191112_human_bham5.sim_nofrag.fasta