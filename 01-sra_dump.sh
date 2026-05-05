#!/bin/sh

# Requires sra-toolkit
# Make a directory for the species of interest with the subdirecties:  RAW_DATA metadata scripts results_annotation logs
# Download the list of SRA accession numbers for the species of interest and save it in the metadata directory

SPECIES_DIR=
cd $SPECIES_DIR/
cat metadata/SRA_accessions.txt |
 while read ACCESSION; do
        if [[  -e RAW_DATA/${ACCESSION}.fastq || -e RAW_DATA/${ACCESSION}_1.fastq ]]; then  continue;
        else
                if [[ ! -e ${ACCESSION}/$ACCESSION.sra ]]; then
                        prefetch  $ACCESSION
                else
                        echo "Prefetch done for $ACESSION, downloading fastq"
                fi
                fasterq-dump --seq-defline "@\$ac.\$si/\$ri"\
                 --split-files ${ACCESSION}/$ACCESSION.sra\
                 --outdir RAW_DATA/
        fi
done
