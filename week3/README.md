# Sample quality control
We now know from reading [Removing the bad apples: A simple bioinformatic method to improve loci-recovery in de novo RADseq data for non-model organisms](https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.13562), that individual samples with low data can negatively affect our ability to call shared SNPs across our datasets. We will take a simple approach to removing low data samples, by running [fastqcR](https://rpkgs.datanovia.com/fastqcr/index.html) on our demultiplexed sample files.
### Background:
> I have written an [RMarkdownscript](https://github.com/DevonDeRaad/RADstackshelpR/blob/master/inst/extdata/fastqcr.Rmd) that uses the R package [fastqcR](https://github.com/kassambara/fastqcr) to generate a report visualizing the quality and quantity of sequencing for each sample, and recommending a subset of samples to be immediately dropped before parameter optimization. The only modification necessary for this script is the path to the folder containing the input .fastq.gz files and the path to your desired output folder. An example report generated using this script can be seen
[here](https://devonderaad.github.io/RADstackshelpR/articles/quality.control.vignette.html). Check out the script itself and the output report to get a feeling for how fastqcR works.
### Step 1:
> Move into your project directory and make a new subdirectory (i.e., folder) to hold quality control information, e.g.:
```
cd work/phil.dicaeum
mkdir qc
```
move into this subdirectory dedicated to sample quality control
```
cd qc
```
### Step 2:
> Download the fastqcR Rmarkdown script into your current directory using the following code:
```
wget https://raw.githubusercontent.com/DevonDeRaad/RADstackshelpR/master/inst/extdata/fastqcr.Rmd
```
Use vim to open the file
```
vi fastqc.Rmd
```
Press 'i' to enter insert mode. Modify the title for your system, author name to your name, and the second chunk to find your fastq files. Press escape and type ':wq' to close the script and save your modifications. If you make a mistake, you can always hit escape and type ':q!' to close the file without saving your modifications.
### Step 3:
> Use vim to construct a submit file that will execute the fastqcR R markdown file as a job, e.g.:
```
#!/bin/sh
#
#SBATCH --job-name=phil.dicaeum.qc             # Job Name
#SBATCH --nodes=1             # nodes
#SBATCH --cpus-per-task=1               # CPU allocation per Task
#SBATCH --partition=sixhour            # Name of the Slurm partition used
#SBATCH --chdir=/home/d669d153/work/phil.dicaeum/qc        # Set working d$
#SBATCH --mem-per-cpu=10gb            # memory requested
#SBATCH --time=360           #time requested

#load R from the pre-installed cluster module
module load R
#run this Rmarkdown script using the PANDOC installation in the BI bin to render the .html output
#this line specifies that the input file is named 'qc.Rmd' and you want the output file named qc.html
R -e "Sys.setenv(RSTUDIO_PANDOC='/panfs/pfs.local/work/bi/bin/pandoc/bin');  rmarkdown::render('qc.Rmd',output_file='qc.html')"
```
### Step 4:
> Execute your submit script with a line like:
```
sbatch run.fastqcr.sh
```
### Step 5:
> Use the following commands to make sure your job is running, or at least queued to start
```
squeue -u KUID
squeue -p bi
squeue --start
```
### Step 6:
> once your job has completed, copy the entire quality control directory onto your local machine using a command like:
```
scp -r d669d153@hpc.crc.ku.edu:/home/d669d153/work/phil.dicaeum/qc /Users/devder/Desktop/phil.dicaeum
```
### Step 7:
> View the file 'qc.html' in a web browser to see how many of your samples fall below the recommended threshold for retaining in downstream analyses. You will want to make note of the file name for each of these samples, so that you can leave them out of the Stacks pipeline, which we will run next week.

### Next week:
> Homework for next week is to read the [Stacks manual](https://catchenlab.life.illinois.edu/stacks/manual/) to get as familiar as possible with the pipeline we will be implementing next week. Please spend as much time as you can familiarizing yourself with this pipeline, understanding it will be key to working with your RAD datasets!
