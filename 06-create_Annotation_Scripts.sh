#!/bin/sh
################################################################################
# Help                                                                         #
################################################################################

Help() {
    # Display Help
    echo "sh ${0}"
    echo "  -j/--logs [log_path]"
    echo "  --acronym [species_acronym]"
    echo "  --assembly [assembly.fasta]"
    echo "  --longOrfsPep [pep]"
    echo "  --predictedPep [TDPredict.pep]"
    echo "  --trinotateDIR [trinotate_data_dir]"
    echo "  -o/--outDIR [annotation outdir]"
    echo ""
    echo "Where:"
    echo "  log_path        = path to save script logs"
    echo "  acronym         = acronym to identify species/assembly"
    echo "  assembly.fasta  = path to your assembly file"
    echo "  longOrfsPep     = path to longest_orfs.pep from TransDecoder.LongOrfs"
    echo "  TDPredict.pep   = output of transdecoder predict"
    echo "  trinotateDIR    = path to trinotate data dir"
    echo "  outDir          = directory for results"
    echo ""
    echo "Example:"
    echo "sh $0 \\"
    echo "  -j SPECIES/logs \\"
    echo "  --acronym Acronym \\"
    echo "  --assembly SPECIES/Trinity_transcriptome.fa \\"
    echo "  --longOrfsPep SPECIES/Trinity_transcriptome.fa_transdecoder_dir/longest_orfs.pep \\"
    echo "  --predictedPep SPECIES/Trinity_transcriptome.fa.transdecoder.pep \\"
    echo "  --trinotateDIR ~/trinotate_dir \\"
    echo "  -o SPECIES"
}

################################################################################
################################################################################
# Main program                                                                 #
################################################################################
################################################################################

createScript() {
    echo "logDIR = $logDIR"
    echo "acronym = $acronym"
    echo "assembly = $assembly"
    echo "longOrfsPep = $longOrfsPep"
    echo "predictedPep = $PredictedPep"
    echo "trinotateDIR = $trinotateDIR"
    echo "outputDIR = $outDir"

    for tool in dogma blastp hmm emapper signalP tmhmm infernal; do
    # Threads
    if [[ $tool == "dogma" ]]; then
        threads=4
    else
        threads=16
    fi
    # Tool Functions
	
## DOGMA
    dogma() {
        echo "#!/bin/sh

source ~/trinotateAnnotation/bin/activate
THREADS=$threads

cd ${outDir}

radiant -i $assembly \\
        -d ${trinotateDIR} \\
        -o ./Radiant.out \\
        --translate;
		
dogma.py transcriptome \\
        -a ./Radiant.out \\
        -o ./dogma.out \\
        -d $trinotate_dir/reference_sets \\
        --reference_transcriptomes monocots
echo Finished radiant and dogma"
    }

## BUSCO
    busco() {
        echo "#!/bin/sh
		
THREADS=$threads

cd ${outDir}

source ~/trinotateAnnotation/bin/activate

busco --offline \\
      --in ${assembly} \\
      --out busco_transcriptome \\
      --lineage_dataset ~/busco/busco_downloads/liliopsida_odb10 \\
      --mode transcriptome \\
      --cpu \$THREADS -f"
    }

## BLASTP

    blastp() {
        echo "#!/bin/sh
		
THREADS=$threads

cd ${outDir}

echo Starting blastp with $(basename $longOrfsPep)

blastp -query $longOrfsPep \\
      -db ${trinotateDIR}/uniprot_sprot.pep \\
      -evalue 1e-5 \\
      -task ${1} \\
      -num_threads \$THREADS \\
      -max_target_seqs 1 \\
      -outfmt '6' \\
      > ${outDir}/$(basename $longOrfsPep)_blastp.out
	  
echo Finished blastp with $(basename $longOrfsPep)"
    }

## HHMSCAN

    hmm() {
        echo "#!/bin/sh
THREADS=$threads
cd ${outDir}
hmmscan \\
      --cpu \$THREADS \\
      --domtblout ${outDir}/$(basename $longOrfsPep)_TrinotatePFAM.out \\
      ${trinotateDIR}/Pfam-A.hmm \\
      ${longOrfsPep}
echo 'Finished HMMScan'"
    }
	
## EggNOG_emapper

    emapper() {
        echo "#!/bin/sh
THREADS=$threads
DATA_DIR=${trinotateDIR}

# Requieres python/3.8, run script 00 to create the virtual environment
source ~/eggnog/bin/activate

cd ${outDir}

emapper.py -i $PredictedPep \\
           --cpu \$THREADS \\
           --data_dir \$DATA_DIR \\
           -o ${outDir}/eggnog_mapper"
    }

## tmhmm

        tmhmm() {
            echo "#!/bin/sh
cd ${outDir}

# Requieres tmhmm/2.0

echo Starting tmhmm

tmhmm --short <\\
  ${PredictedPep} >\\
  ${outDir}/$(basename $PredictedPep)_tmhmm.out

echo Finished tmhmm
"
    }

## signalP

   signalP() {
        echo "#!/bin/sh
		
cd ${outDir}
# Requieres python/3.11 signalp6, run script 00 to create the virtual environment

source ~/ENV2023/bin/activate

signalp6 --fastafile ${PredictedPep} \\
         --model_dir ~/ENV2023/lib/python3.11/site-packages/signalp/model_weights \\
         --organism other \\
         --output_dir ./ \\
         --format none \\
         --mode fast"
    }

## INFERNAL

    infernal() {
        echo "#!/bin/sh
THREADS=$threads

# Requieres trinotate/4.0.0 infernal

cd ${outDir}
Trinotate --db ../Trinotate.sqlite \\
          --CPU \$THREADS \\
          --transcript_fasta ${assembly} \\
          --transdecoder_pep ${PredictedPep} \\
          --trinotate_data_dir ${trinotateDIR} \\
          --run 'infernal'"
    }

    # Merge header and script
    case ${tool} in
        dogma | blastp | hmm | busco)     		${tool} > ${logDIR}/../scripts/07-${tool}.sh ;;
        tmhmm | signalP | emapper | infernal)	${tool} > ${logDIR}/../scripts/09-${tool}.sh ;;
    esac
done
}

################################################################################
################################################################################
# Process flags                                                                #
################################################################################
################################################################################

for flag in $*
do
    case $flag in
        -j | --logDIR) 	export logDIR=${2}; shift 2;;
        --acronym) 		export acronym=${2}; shift 2;;
        --assembly) 	export assembly=${2}; shift 2;;
        --longOrfsPep) 	export longOrfsPep=${2}; shift 2;;
        --predictedPep) export PredictedPep=${2}; shift 2;;
        --trinotateDIR) export trinotateDIR=${2}; shift 2;;
        -o | --outDIR) 	export outDir=${2}; shift 2;;
        -h | --help) 	Help; exit;;
    esac
done

createScript
