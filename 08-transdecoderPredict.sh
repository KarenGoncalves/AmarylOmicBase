#!/bin/sh
# Requieres transdecoder trinotate/4.0

SPECIES=
SPECIES_DIR=
ASSEMBLY=
TrinotatePFAM=
blastp6_out=
TRINOTATE_HOME= # where trinotate is installed 

source ~/trinotateAnnotation/bin/activate

TransDecoder.Predict\
 -t $ASSEMBLY\
 --output_dir $SPECIES_DIR\
 --retain_pfam_hits ${TrinotatePFAM}\
 --retain_blastp_hits ${blast6_out}\
 --single_best_only

$TRINOTATE_HOME/util/trinotateSeqLoader/TrinotateSeqLoader.pl\
 --sqlite $SPECIES_DIR/Trinotate.sqlite\
 --gene_trans_map $SPECIES_DIR/${SPECIES}_gene_trans_map\
 --transcript_fasta ${ASSEMBLY}\
 --transdecoder_pep ${ASSEMBLY}.transdecoder.pep\
 --bulk_load
