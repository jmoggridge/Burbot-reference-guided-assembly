#!/bin/sh

#SBATCH --account=def-nricker
#SBATCH --time=0-01:00:00 ## days-hours:minutes:seconds
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4 # number of threads
#SBATCH --mem=16000 # requested memory (in MB)
#SBATCH --mail-type=END

########## BWA Alignment ###################

echo "Starting run_bwa_cod.sh"

## using bwa aligner
module load bwa/0.7.17

## align each individual fastq file to COD ref using BWA
for file in *.fq.gz; do
  basename=`echo $file | sed 's/\.fq\.gz//'`;
  echo "Starting alignment of $basename to reference genome";
  bwa mem -t 16 cod_reference_genome/GCF_902167405.1_gadMor3.0_genomic.fna $file >  $basename.bwa.cod.sam
done

