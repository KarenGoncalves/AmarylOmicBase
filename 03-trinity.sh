#!/bin/sh

ACRONYM= # an acronym to identificate the species by
SPECIES= # Species name (Only letters, numbers and _)
SPECIES_DIR=
MAXMEM=200 # 200G of memory by default, increase if necessary
THREADS=2 # inscrease if necessary

############### samples_file.txt is a file with 4 columns:
#### sample_name replicate_name /FULL/PATH/TO/READ_1.fastq.gz /FULL/PATH/TO/READ_2.fastq.gz
#### 1 line per replicate

# Requieres perl/5.30.2 metaeuk/6 r/4.3.1 samtools/1.17 jellyfish python/3.10.2 scipy-stack bowtie2/2.4.1 salmon/1.7 trinity/2.14.0 cd-hit

source ~/trinotateAnnotation/bin/activate
cd $SPECIES_DIR
layoutTypes=$(cut -f 3 $PWD/metadata/metadata.txt | sort | uniq | wc -l)

if [[ $layoutTypes -eq 1 ]]; then
	Trinity --seqType fq --max_memory ${MAXMEM}G\
	 --output Trinity\
	 --CPU $THREADS\
	 --samples_file $SPECIES_DIR/metadata/samples_file.txt\
	 --normalize_by_read_set --full_cleanup
else 
	R1=($(cut -f 3 $SPECIES_DIR/metadata/samples_file.txt))
	R2=($(awk '$4 != "" {printf $4" "}' $SPECIES_DIR/metadata/samples_file.txt))
	cat ${R1[@]} > R1.fq
	cat ${R2[@]} > R2.fq

	Trinity --seqType fq --max_memory ${MAXMEM}G\
	 --output Trinity\
	 --CPU $THREADS\
	 --left R1.fq --right R2.fq\
	 --no_normalize_reads --full_cleanup
fi

# run CDHIT if trinity worked
if [[ -e Trinity.Trinity.fasta.gene_trans_map ]]; then

	# Add species acronym to transcript names
        sed -E "s/>(TRINITY)/>${ACRONYM}\1/g"\
         Trinity.Trinity.fasta >\
         $SPECIES_DIR/og_transcriptome.fa

        sed -E "s/(TRINITY)/${ACRONYM}\1/g"\
         Trinity.Trinity.fasta.gene_trans_map >\
         $SPECIES_DIR/og_gene_trans_map

	# Remove redundancies
        cd-hit-est\
         -i $SPECIES_DIR/og_transcriptome.fa\
         -o $SPECIES_DIR/tmp\
         -c 0.97 -l 200\
         -T 0 -M 4000M
        # -c is the similarity threshold
        # -l is the minimum length threshold
        # -T threads; -M memory in megabytes

	source Amaryllidoideae_transcriptomes/format_fasta.sh

        format_fasta $SPECIES_DIR/tmp $SPECIES_DIR/${SPECIES}_nt97.fa

        # Create new gene_trans_map

        $TRINITY_HOME/util/support_scripts/get_Trinity_gene_to_trans_map.pl\
	 $SPECIES_DIR/${SPECIES}_nt97.fa >\
         $SPECIES_DIR/${SPECIES}_gene_trans_map
else
        echo "Trinity failed"
fi
