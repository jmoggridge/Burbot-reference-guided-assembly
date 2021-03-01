#!/bin/sh

#SBATCH --account=def-nricker
#SBATCH --time=0-01:00:00 ## days-hours:minutes:seconds
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4 # number of threads
#SBATCH --mem=16000 # requested memory (in MB)
#SBATCH --mail-type=END

echo "Starting run_bwa_burbot.sh"
module load bwa/0.7.17

## align each individual fastq file to BURBOT ref using BWA
for file in *.fq.gz; do
  basename=`echo $file | sed 's/\.fq\.gz//'`;
  echo "Starting alignment of $basename to reference genome";
  bwa mem -t 16 burbot_reference_genome/GCA_900302385.1_ASM90030238v1_genomic.fna $file >  $basename.bwa.burbot.sam
done

echo "Completed run_alignments.sh"
