#!/bin/sh

SPECIES=
SPECIES_DIR=
results_d=$SPECIES_DIR/results_annotation 
ASSEMBLY=$SPECIES_DIR/${SPECIES}_nt97.fa
db=$SPECIES_DIR/Trinotate.sqlite

# Requieres trinotate/4.0.0 or higher

Trinotate --db $db\
 --LOAD_swissprot_blastp $results_d/longest_orfs.pep_blastp.out\
 --LOAD_pfam $results_d/longest_orfs.pep_TrinotatePFAM.out\
 --LOAD_signalp $results_d/output.gff3\
 --LOAD_EggnogMapper $results_d/eggnog_mapper.emapper.annotations\
 --LOAD_tmhmmv2 $results_d/${SPECIES}_nt97.fa.transdecoder.pep_tmhmm.out\
 --LOAD_infernal $results_d/infernal.out

Trinotate --db $db --report\
 --incl_pep --incl_trans > $SPECIES_DIR/${SPECIES}_trinotate4.tsv

echo $SPECIES_DIR/${SPECIES}_trinotate4.tsv is done
