function format_fasta () {
inFasta=$1
outFasta=$2

awk '!/^>/ { printf "%s", $0; n = "\n" }\
 /^>/ { print n $0; n = "" }\
 END { printf "%s", n }\
 ' $inFasta  > $outFasta
}

