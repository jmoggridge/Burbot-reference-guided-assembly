#!/bin/sh

## This script uses bwa and bowtie2 to map reads (.fq.gz) 
## from individual burbots to both cod and burbot reference genome

## Usage: sbatch run_bowtie_align.sh

#SBATCH --account=def-nricker
#SBATCH --time=0-03:00:00 ## days-hours:minutes:seconds
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4 # number of threads
#SBATCH --mem=16000 # requested memory (in MB)
#SBATCH --mail-type=END

echo "Starting run_bowtie_align.sh"

########## Bowtie2 Alignment ###################

module load bowtie2

## align each individual fastq file to COD ref using BOWTIE2
echo "Starting Bowtie2 alignments to cod reference"
for file in *.fq.gz; do
  basename=`echo $file | sed 's/\.fq\.gz//'`;
  echo "Starting alignment of $basename to reference genome";
  bowtie2 -x cod_reference_genome/GCF_902167405.1_gadMor3.0_genomic -U $file -S $basename.bowtie.cod.sam --very-sensitive-local;
done


#!/bin/sh

#SBATCH --account=def-nricker
#SBATCH --time=0-00:40:00 ## days-hours:minutes:seconds
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4 # number of threads
#SBATCH --mem=16000 # requested memory (in MB)
#SBATCH --mail-type=END

echo "Starting run_bowtie2_burbot.sh"

########## Bowtie2 Burbot ###################


## align each individual fastq file to BURBOT ref using BOWTIE2
echo "Starting Bowtie2 alignments to Burbot reference"
for file in *.fq.gz; do
  basename=`echo $file | sed 's/\.fq\.gz//'`;
  echo "Starting alignment of $basename to reference genome";
  bowtie2 -x burbot_reference_genome/GCA_900302385.1_ASM90030238v1_genomic -U $file -S $basename.bowtie.burbot.sam --very-sensitive-local;
done

echo "Completed run_alignments.sh"
