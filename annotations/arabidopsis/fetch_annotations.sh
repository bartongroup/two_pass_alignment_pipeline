set -euo pipefail

echo "Fetching genome from ensembl"
curl "ftp://ftp.ensemblgenomes.org/pub/plants/release-35/fasta/arabidopsis_thaliana/dna/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz" |
zcat > "Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"

samtools faidx "Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"
cut -f-2 "Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.fai" > "Arabidopsis_thaliana.TAIR10..chrom.sizes"

echo "Fetching AtRTD2 annotations"
curl "https://ics.hutton.ac.uk/atRTD/RTD2/AtRTD2_19April2016.fa" |
sed -r -e "s/>(.+)_(.+)+( gene|$)/>\1-\2\3/" > "AtRTD2_19April2016.fa"

curl "https://ics.hutton.ac.uk/atRTD/RTD2/AtRTD2_19April2016.gtf" |
sed -r -e "s/^Chr//" -e 's/transcript_id "([^"]+)_([^"]+)"/transcript_id "\1-\2"/g' > "AtRTD2_19April2016.gtf"
