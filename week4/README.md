# Running the Stacks pipeline
### Last week
> After running [fastqcR](https://rpkgs.datanovia.com/fastqcr/index.html) on our demultiplexed sample files last week, we should now have a feeling for the distribution of raw reads among our sequenced samples, and a .html document that can be accessed at any time to review this quality information. Saving our code and these output documents is key for reproducibility and transparency once we are ready to put our projects out into the world. For now, I will save my .html output file in a stable directory on my local computer and follow the recommended (arbitrary) cutoff threshold for removing low data samples.
### Today:
> Today we will be using the quality control information to remove bad apples immediately, and perform a preliminary Stacks run.
### Step 1:
> Copy the following script into a text editor on your local machine, and edit the specific details to match your project
```
#!/bin/sh
#
#SBATCH --job-name=preliminary.stacks.run           # Job Name
#SBATCH --nodes=1             # nodes
#SBATCH --cpus-per-task=15               # CPU allocation per Task
#SBATCH --partition=bi            # Name of the Slurm partition used
#SBATCH --chdir=/home/username/work/project.directory # Set working directory
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
```
The only lines that will need to be customized for your project are:
1. Line beginning with '#SBATCH --chdir=' will need to be set to the full path of your project directory
2. Line beginning with 'files="sample 1' which sets the $files variable (variables are called with a preceeding dollar sign in bash) will need to be customized to include only the samples you want to run through Stacks.

The quickest way to do this is probably to go to the file you made during week 2, called 'plate.1.barcodes.txt', and copy out all of the sample names (this will also ensure that your sample names match the names of the fq.gz files), and paste them into the script.

We also need to remove samples that fell below our read count threshold, which can be done by simply removing the name of sample that fell below the threshold from this script.

![img](remove.samples.png "Title")

### Step 2:
remember our file tree currently looks like:
```
home          (*you are here when you log into the cluster)
  |_work
      |_project.directory
              |_raw.data
              |_fastq
              |_qc
```
> Log into the cluster and move down your file tree, into your project directory, e.g.:
```
cd work/project.directory
```
> Result of moving down the file tree:
```
home          
  |_work
      |_project.directory (*you are now here)
              |_raw.data
              |_fastq
              |_qc
```

> Now copy in your customized script to run a preliminary Stacks instance, and name it 'run.prelim.stacks.sh'
```
vi run.prelim.stacks.sh
```
> Follow these steps to paste in the script and save the file
```
*press 'i' to enter insert mode*
*paste in customized script from your local text editor*
*press 'escape' to exit insert mode*
type ':wq' and hit enter to save and close the file
```

### Step 3: Make the pipeline_popmap.txt file referenced in the above script

We are still in the folder 'project directory'. If you run 'ls -lh' you should now see your script 'run.prelim.stacks.sh' in your current working directory

> You will want to create the 'pipeline_popmap.txt' file in a local text editor. The format must be 'sampleID'\t'population' ('\t' is the syntax for a tab character), e.g.;
```
sample1   pop1
sample2   pop1
sample3   pop1
sample4   pop1
sample5   pop1
```

The simplest way to make this file is to copy your 'files' variable assignment from the above script into a text editor, and then add a tab and a population after each sample.

#### Note: your popmap must contain the exact individuals that you are running through Stacks in your submit script, no more, no less.

Once you have this popmap text file prepared in a local text editor, repeat the above steps to copy it into a new file in your working directory on the cluster named 'pipeline_popmap.txt'
```
vi pipeline_popmap.txt
```
> Follow these steps to paste in the script and save the file
```
*press 'i' to enter insert mode*
*paste in customized popmap from your local text editor*
*press 'escape' to exit insert mode*
type ':wq' and hit enter to save and close the file
```

### Step 4:
> Submit your job script and ensure that it begins running:
```
#submit job
sbatch run.prelim.stacks.sh
#check your running jobs
squeue -u *your username*
#list the files in your working directory
ls -lh
```
Our file tree should now look like:
```
home  
  |_work
      |_project.directory     (*you are here)
              |_fastq
              |_qc
              |_raw.data
              |_stacks.prelim
```
You will notice that the directory 'stacks.prelim' has been generated within our submit script. This directory will hold all the output files from our preliminary Stacks run

> Check on your submitted job, which should still be running, and should run for a few more hours.
```
#check your running jobs
squeue -u *your username*
#list the files in the 'stacks.prelim' directory
ls -lh stacks.prelim/
```
Your job should still be running, and you should see the 'stacks.prelim' directory filling up with files. If your job has already finished, there is likely an error in your script. Use the command 'less' to open the resulting slurm output file and try to diagnose what went wrong from the error message!

### Step 5: Rinse and repeat
If you get an error, repeat the process of submitting your job, checking that it is running, checking on the output directory, and troubleshooting any errors that come up until it runs smoothly. For the preliminary popgen analyses we do next week, you will need a successfully completed Stacks run, which will be indicated by your submit job running for a few hours without failure, and successfully writing a file to the 'stacks.prelim' directory called 'populations.snps.vcf' which holds your output SNP data. 
