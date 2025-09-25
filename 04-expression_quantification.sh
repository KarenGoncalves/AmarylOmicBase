#!/bin/sh
SPECIES_DIR= # full path
ASSEMBLY=
GENE_TRANS_MAP=
THREADS=2 # inscrease if necessary

############### samples_file.txt is a file with 4 columns:
#### sample_name replicate_name /FULL/PATH/TO/READ_1.fastq.gz /FULL/PATH/TO/READ_2.fastq.gz
#### 1 line per replicate

# Requieres kallisto trinity samtools r/4.3.1


# BEFORE RUNNING THIS SCRIPT #
# install the R packages tidyverse (CRAN) and edgeR (bioconductor)

mkdir $SPECIES_DIR/kallisto
cd $SPECIES_DIR/kallisto/

##### Estimate abundance #####
$TRINITY_HOME/util/align_and_estimate_abundance.pl\
 --transcripts ${ASSEMBLY}\
 --seqType fq\
 --samples_file $SPECIES_DIR/metadata/samples_file.txt\
 --est_method kallisto\
 --output_dir $SPECIES_DIR/kallisto/\
 --thread_count $THREADS\
 --gene_trans_map ${GENE_TRANS_MAP}\
 --prep_reference

# Abundance files to matrix
ls */abundance.tsv > $SPECIES_DIR/metadata/list_abundance_files

$TRINITY_HOME/util/abundance_estimates_to_matrix.pl\
 --est_method kallisto\
 --gene_trans_map ${GENE_TRANS_MAP}\
 --name_sample_by_basedir\
 --quant_files $SPECIES_DIR/metadata/list_abundance_files


# Get list of expressed isoforms (at least one read count in the whole experiment
Rscript ~/annotation_scripts/exclude_non_expressed_isoforms.R\
 $GENE_TRANS_MAPDIR/kallisto/\
 .isoform.counts.matrix\
 _filtered_isoforms\
 kallisto

