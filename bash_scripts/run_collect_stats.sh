#!/bin/sh

#SBATCH --account=def-nricker
#SBATCH --time=0-00:10:00 ## days-hours:minutes:seconds
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4 # number of threads
#SBATCH --mem=4000 # requested memory (in MB)
#SBATCH --mail-type=END

module load samtools

# create csv file with header
touch alignments_data.csv
echo "Sample,Aligner,Reference,Total,Mapped,Unmapped,mQ0,AverageQuality,TotalLength,BasesMapped,Mismatches,AverageLength,MaxLength,PercentMapped,Secondary,Supplementary" > alignments_data.csv

for file in *.sam; do
  echo $file;
  sample=`echo $file | sed 's/\..*//'`;
  if echo $file | grep -q 'bwa'; then
    aligner='bwa'
  elif echo $file | grep -q 'bowtie'; then
    aligner='bowtie2'
  fi;
  if echo $file | grep -q 'cod'; then
    reference='cod'
  elif echo $file | grep -q 'burbot'; then
    reference='burbot'
  fi;
  touch temp;
  samtools stats $file > temp;
  total=`grep 'raw total sequences' temp | cut -f3`;
  mapped=`grep 'reads mapped:' temp | cut -f3`;
  unmapped=`grep 'reads unmapped:' temp | cut -f3`;
  mQ0=`grep 'reads MQ0:' temp | cut -f3`;
  averageQuality=`grep 'average quality:' temp | cut -f3`;
  totalLength=`grep 'total length:' temp | cut -f3`;
  basesMapped=`grep 'bases mapped cigar:' temp | cut -f3`;
  mismatches=`grep 'error rate:' temp | cut -f3`;
  averageLength=`grep 'average length' temp | cut -f3`;
  maximumLength=`grep 'maximum length' temp | cut -f3`;
  samtools flagstats $file > temp;
  percent_mapped=`grep % temp | sed -r 's/.*\(|% : .*\)//g'`;
  secondary=`grep 'secondary' temp | sed 's/ + 0 secondary//'`
  supplementary=`grep 'supplementary' temp | sed 's/ + 0 supplementary//'`
  echo "$sample,$aligner,$reference,$total,$mapped,$unmapped,$mQ0,$averageQuality,$totalLength,$basesMapped,$mismatches,$averageLength,$maximumLength,$percent_mapped,$secondary,$supplementary" >> alignments_data.csv;
done
rm temp