set -euo pipefail

echo "Fetching genome from ensembl"
curl "ftp://ftp.ensembl.org/pub/release-99/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz" |
zcat > "Mus_musculus.GRCm38.dna.primary_assembly.fa"

samtools faidx "Mus_musculus.GRCm38.dna.primary_assembly.fa"
cut -f-2 "Mus_musculus.GRCm38.dna.primary_assembly.fa.fai" >  "Mus_musculus.GRCm38.dna.primary_assembly.chrom.sizes"

echo "Fetching ensembl annotations"
curl "ftp://ftp.ensembl.org/pub/release-99/fasta/mus_musculus/cdna/Mus_musculus.GRCm38.cdna.all.fa.gz" |
zcat > "Mus_musculus.GRCm38.cdna.all.fa"

curl "ftp://ftp.ensembl.org/pub/release-99/gtf/mus_musculus/Mus_musculus.GRCm38.99.gtf.gz" |
zcat > "Mus_musculus.GRCm38.99.gtf"