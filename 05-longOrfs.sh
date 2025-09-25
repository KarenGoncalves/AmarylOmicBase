#!/bin/sh

# Requieres transdecoder

SPECIES=
SPECIES_DIR=
ASSEMBLY=
GENE_TRANS_MAP=

if [[ ! -e $GENE_TRANS_MAP ]]; then
	ml trinity
	$TRINITY_HOME/util/support_scripts/get_Trinity_gene_to_trans_map.pl\
	 ${ASSEMBLY} > ${GENE_TRANS_MAP}
fi

TransDecoder.LongOrfs\
 -t $ASSEMBLY\
 --gene_trans_map $GENE_TRANS_MAP\
 --output_dir $SPECIES_DIR
