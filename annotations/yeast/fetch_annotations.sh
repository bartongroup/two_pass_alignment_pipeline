set -euo pipefail

echo "Fetching genome from ensembl"
curl "ftp://ftp.ensembl.org/pub/release-99/fasta/saccharomyces_cerevisiae/dna/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz" |
zcat > "Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa"

samtools faidx "Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa"
cut -f-2 "Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.fai" > "Saccharomyces_cerevisiae.R64-1-1.dna.chrom.sizes"

echo "Fetching ensembl annotations"
curl "ftp://ftp.ensembl.org/pub/release-99/fasta/saccharomyces_cerevisiae/cdna/Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa.gz" |
zcat > "Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa"

curl "ftp://ftp.ensembl.org/pub/release-99/gtf/saccharomyces_cerevisiae/Saccharomyces_cerevisiae.R64-1-1.99.gtf.gz" |
zcat > "Saccharomyces_cerevisiae.R64-1-1.99.gtf"