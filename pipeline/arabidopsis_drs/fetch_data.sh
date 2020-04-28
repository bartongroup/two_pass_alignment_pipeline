set -euo pipefail

# REP 1
mkdir -p 20180201_1617_20180201_FAH45730_WT_Col0_2916_regular_seq/raw_data
curl https://zenodo.org/record/3773729/files/201901_col0_2916.dna.fastq \
 > 20180201_1617_20180201_FAH45730_WT_Col0_2916_regular_seq/raw_data/201901_col0_2916.dna.fastq
 
mkdir -p 20180201_1617_20180201_FAH45730_WT_Col0_2916_regular_seq/simulated_data
curl https://zenodo.org/record/3773729/files/201901_col0_2916.sim_nofrag.fasta \
 > 20180201_1617_20180201_FAH45730_WT_Col0_2916_regular_seq/simulated_data/201901_col0_2916.sim_nofrag.fasta
python ../../scripts/get_sim_counts_from_reads.py \
  20180201_1617_20180201_FAH45730_WT_Col0_2916_regular_seq/simulated_data/201901_col0_2916.sim_nofrag.fasta \
  20180201_1617_20180201_FAH45730_WT_Col0_2916_regular_seq/simulated_data/201901_col0_2916_quant.tsv \
  ../../annotations/arabidopsis/AtRTD2_19April2016.gtf \
  20180201_1617_20180201_FAH45730_WT_Col0_2916_regular_seq/simulated_data/201901_col0_2916_simulated_reference.gtf

# REP 2
mkdir -p 20180413_1558_20180413_FAH77434_mRNA_WT_Col0_2917/raw_data
curl https://zenodo.org/record/3773729/files/201901_col0_2917.dna.fastq \
 > 20180413_1558_20180413_FAH77434_mRNA_WT_Col0_2917/raw_data/201901_col0_2917.dna.fastq
 
mkdir -p 20180413_1558_20180413_FAH77434_mRNA_WT_Col0_2917/simulated_data
curl https://zenodo.org/record/3773729/files/201901_col0_2917.sim_nofrag.fasta \
 > 20180413_1558_20180413_FAH77434_mRNA_WT_Col0_2917/simulated_data/201901_col0_2917.sim_nofrag.fasta
python ../../scripts/get_sim_counts_from_reads.py \
  20180413_1558_20180413_FAH77434_mRNA_WT_Col0_2917/simulated_data/201901_col0_2917.sim_nofrag.fasta \
  20180413_1558_20180413_FAH77434_mRNA_WT_Col0_2917/simulated_data/201901_col0_2917_quant.tsv \
  ../../annotations/arabidopsis/AtRTD2_19April2016.gtf \
  20180413_1558_20180413_FAH77434_mRNA_WT_Col0_2917/simulated_data/201901_col0_2917_simulated_reference.gtf 
 

# REP 3
mkdir -p 20180416_1534_20180415_FAH83697_mRNA_WT_Col0_2918/raw_data
curl https://zenodo.org/record/3773729/files/201901_col0_2918.dna.fastq \
 > 20180416_1534_20180415_FAH83697_mRNA_WT_Col0_2918/raw_data/201901_col0_2918.dna.fastq

mkdir -p 20180416_1534_20180415_FAH83697_mRNA_WT_Col0_2918/simulated_data
curl https://zenodo.org/record/3773729/files/201901_col0_2918.sim_nofrag.fasta \
 > 20180416_1534_20180415_FAH83697_mRNA_WT_Col0_2918/simulated_data/201901_col0_2918.sim_nofrag.fasta
python ../../scripts/get_sim_counts_from_reads.py \
  20180416_1534_20180415_FAH83697_mRNA_WT_Col0_2918/simulated_data/201901_col0_2918.sim_nofrag.fasta \
  20180416_1534_20180415_FAH83697_mRNA_WT_Col0_2918/simulated_data/201901_col0_2918_quant.tsv \
  ../../annotations/arabidopsis/AtRTD2_19April2016.gtf \
  20180416_1534_20180415_FAH83697_mRNA_WT_Col0_2918/simulated_data/201901_col0_2918_simulated_reference.gtf 


#REP 4
mkdir -p 20180418_1428_20180418_FAH83552_mRNA_WT_Col0_2919/raw_data
curl https://zenodo.org/record/3773729/files/201901_col0_2919.dna.fastq \
 > 20180418_1428_20180418_FAH83552_mRNA_WT_Col0_2919/raw_data/201901_col0_2919.dna.fastq
 
mkdir -p 20180418_1428_20180418_FAH83552_mRNA_WT_Col0_2919/simulated_data
curl https://zenodo.org/record/3773729/files/201901_col0_2919.sim_nofrag.fasta \
 > 20180418_1428_20180418_FAH83552_mRNA_WT_Col0_2919/simulated_data/201901_col0_2919.sim_nofrag.fasta
python ../../scripts/get_sim_counts_from_reads.py \
  20180418_1428_20180418_FAH83552_mRNA_WT_Col0_2919/simulated_data/201901_col0_2919.sim_nofrag.fasta \
  20180418_1428_20180418_FAH83552_mRNA_WT_Col0_2919/simulated_data/201901_col0_2919_quant.tsv \
  ../../annotations/arabidopsis/AtRTD2_19April2016.gtf \
  20180418_1428_20180418_FAH83552_mRNA_WT_Col0_2919/simulated_data/201901_col0_2919_simulated_reference.gtf 