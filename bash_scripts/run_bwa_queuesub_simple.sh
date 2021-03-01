#!/bin/sh

## This script uses bwa to map reads (.fastq) to reference genome
## usage (for testing with just one individual):

## Usage: sbatch run_bwa_queuesub.sh EGM16_0001.fastq

#SBATCH --account=def-nricker
#SBATCH --time=0-00:15:00 ## days-hours:minutes:seconds
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4 # number of threads
#SBATCH --mem=16000 # requested memory (in MB)
#SBATCH --mail-type=END

module load bwa/0.7.17

## Take name of fastq (input file) and pull off ".fastq" so you have a basename
## This is a convenience so we can point this script at any .fastq file and name the output file appropriately

fastq=$1
basename=`echo $fastq | sed 's/\.fastq//'`

## "echo" statements print to log
echo "Starting alignment of $fastq to reference genome"
echo $fastq

## run bwa to align reads to .fasta.
## note, these are relative paths, for running within this directory
bwa mem -t 16 SalmoSalar/SalmoSalar.fasta  $fastq >  $basename.sam


