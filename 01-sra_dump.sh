#!/bin/sh

# Requires sra-toolkit
# Make a directory for the species of interest with the subdirecties:  RAW_DATA metadata scripts results_annotation logs
# Download the list of SRA accession numbers for the species of interest and save it in the metadata directory

SPECIES_DIR=
cd $SPECIES_DIR/

cat metadata/SRA_accessions.txt |
 while read ACCESSION; do
	 fasterq-dump\
	 --seq-defline '@$sn[_$rn]/$ri'\
	 --split-files ${ACCESSION}\
	 --outdir RAW_DATA/ 
done
