# filter fasta by length #
#### USAGE ####
# Filter out small proteins (eg. < 300 aa): filterByLength_fasta $INPUT_FASTA $OUTPUT_FASTA 300 0
# Filter out big proteins (eg. > 1500 aa): filterByLength_fasta $INPUT_FASTA $OUTPUT_FASTA 0 1500
# Filter out both small and big proteins (eg. <300 and > 1500 aa): filterByLength_fasta $INPUT_FASTA $OUTPUT_FASTA 300 1500

function filterByLength_fasta () {
inFasta=$1
outFasta=$2
minlength=$3
maxlength=$4

if [[ $maxlegth -eq 0 ]]; then
  awk -vRS=">" -vORS="" -vFS="\n" -vOFS="\n" -vMiL=$minlength\
 'length($2) > MiL {print ">"$0}' $inFasta > $outFasta
 elif [[ $minlength -eq 0 ]]; then
  awk -vRS=">" -vORS="" -vFS="\n" -vOFS="\n" -vMaL=$maxlength\
 'length($2) < MaL {print ">"$0}' $inFasta > $outFasta
 else
awk -vRS=">" -vORS="" -vFS="\n" -vOFS="\n" -vMiL=$minlength -vMaL=$maxlength\
 'length($2) > MiL && length($2) < MaL {print ">"$0}' $inFasta > $outFasta
 fi
}
