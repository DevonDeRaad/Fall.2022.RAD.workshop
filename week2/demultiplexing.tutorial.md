# Demultiplexing tutorial

These are the basic steps to demultiplex single-end, single-barcode data on the KU High Performance Computing Cluster.

### Step 1:
> Create a new directory on the cluster that will hold all the files associated with your project.
```
  #move into the work dirctory
  cd work
  #make new directory to hold your project
  mkdir phil.dicaeum
  #move into directory you created
  cd phil.dicaeum
  #make a subdirectory to hold your raw illumina data
  mkdir raw.data
  #make a subdirectory to hold your demultiplexed sample fastq files
  mkdir fastq
```
### Step 2:
> Copy in your raw illumina data, see last week's tutorial for doing this directly from KU RFS [here](https://github.com/DevonDeRaad/Fall.2022.RAD.workshop/blob/main/week1/move.files.between.RFS.and.KUHPCC.md).
```
 #move into the folder you want the file in
 cd /home/KUID/work/new.directory/raw.data
 #copy in the raw illumina data
 cp /home/d669d153/scratch/CES-MSG-NdeI-P1-96_S1_R1_001.fastq.gz .
```
### Step 3:
> Construct barcodes file that identifies each of your samples (structure is 'barcode \t sample.name'). Full example file [here](https://github.com/DevonDeRaad/aph.rad/blob/master/sequencedata.to.snps/plate.1.barcodes.txt).
```
#example of how the barcode file should look for single-barcode data
TAATTG	A_californica_333849
TCTCTG	A_californica_333854
AACCTG	A_californica_333855
TGTAAT	A_californica_333857
```
### Step 4:
> Construct a submit script that will execute Stacks function [process_radtags](https://catchenlab.life.illinois.edu/stacks/comp/process_radtags.php).
```
vi process.radtags.sh
```
press 'i' to enter 'insert mode' and copy the following script into your file:
```
#!/bin/sh
#
#SBATCH --job-name=process.radtags            # Job Name
#SBATCH --nodes=1              #nodes
#SBATCH --ntasks-per-node=1             #CPU allocation per Task
#SBATCH --partition=bi          # Name of the Slurm partition used
#SBATCH --chdir=/home/d669d153/work/phil.dicaeum/      # Set working d$
#SBATCH --mem-per-cpu=5gb            # memory requested
#SBATCH --time=1000             #time requested in minutes

#-p specifies the input folder where the raw data is
#-o specifies the output data to write individual sample fastq files to
#-b specifies sample barcodes
#-e specifies the enzyme used, so that process_radtags can look for the correct RAD cutsite
#-c,--clean — clean data, remove any read with an uncalled base.
#-q,--quality — discard reads with low quality scores.
#-r,--rescue — rescue barcodes and RAD-Tag cut sites.
/home/d669d153/work/stacks-2.3b/process_radtags -p raw.data  -o fastq -b plate.1.barcodes.txt -e ndeI -r -c -q
```
now press 'escape', type ':wq', and hit 'enter' to close and save your script*
### Step 5:
> Execute your submit script using the following command
```
sbatch process.radtags.sh
```
### Step 6:
> Use the following commands to make sure your job is running, or at least queued to start
```
squeue -u KUID
squeue -p bi
squeue --start
```
