#!/bin/sh
#
#SBATCH --job-name=preliminary.stacks.run           # Job Name
#SBATCH --nodes=1             # nodes
#SBATCH --cpus-per-task=15               # CPU allocation per Task
#SBATCH --partition=bi            # Name of the Slurm partition used
#SBATCH --chdir=/home/username/work/project.directory # Set working d$
#SBATCH --mem-per-cpu=1gb            # memory requested
#SBATCH --time=3000

files="sample1
sample2
sample3
sample4
sample5"

#create a directory to hold this unique iteration:
mkdir stacks.prelim
#run ustacks in a loop for each sample, with all parameters set to default, using 15 threads
id=1
for sample in $files
do
/home/d669d153/work/stacks-2.41/ustacks -f fastq/${sample}.fq.gz -o stacks.prelim -i $id -p 15
let "id+=1"
done

## Run cstacks to compile stacks between samples. Popmap is a file in working directory called 'pipeline_popmap.txt'
/home/d669d153/work/stacks-2.41/cstacks -P stacks.prelim -M pipeline_popmap.txt -p 15

## Run sstacks. Match all samples supplied in the population map against the catalog.
/home/d669d153/work/stacks-2.41/sstacks -P stacks.prelim -M pipeline_popmap.txt -p 15

## Run tsv2bam to transpose the data so it is stored by locus, instead of by sample.
/home/d669d153/work/stacks-2.41/tsv2bam -P stacks.prelim -M pipeline_popmap.txt -t 15

## Run gstacks: align reads per sample, call variant sites in the population, genotypes in each individual.
/home/d669d153/work/stacks-2.41/gstacks -P stacks.prelim -M pipeline_popmap.txt -t 15

## Run populations completely unfiltered and output unfiltered vcf, we will do filtering using the SNPfiltR package
/home/d669d153/work/stacks-2.41/populations -P stacks.prelim -M pipeline_popmap.txt --vcf -t 15
