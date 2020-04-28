set -euo pipefail

echo "Fetching genome from ensembl"
curl "ftp://ftp.ensembl.org/pub/release-98/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz" |
zcat > "Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"

samtools faidx "Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"
cut -f-2 "Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.fai" >  "Homo_sapiens.GRCh38.dna_sm.primary_assembly.chrom.sizes"

echo "Fetching ensembl annotations"
curl "ftp://ftp.ensembl.org/pub/release-98/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz" |
zcat > "Homo_sapiens.GRCh38.cdna.all.fa"

curl "ftp://ftp.ensembl.org/pub/release-98/gtf/homo_sapiens/Homo_sapiens.GRCh38.98.gtf.gz" |
zcat > "Homo_sapiens.GRCh38.98.gtf"