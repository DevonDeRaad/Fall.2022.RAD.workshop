# Optimizing denovo Stacks assembly parameter 'm'
### Last week:
Last week we created a phylogenetic network to ensure that sample clustering patterns make sense, and we aren't dealing with obvious issues of mis-identification, contamination, incorrect bar-code specifications, etc. Now you should have a set of samples that you feel confident in using to optimize the parameter settings for [Stacks](https://catchenlab.life.illinois.edu/stacks/) denovo assembly.

### This week:
We are eventually going to optimize three parameters used during the [Stacks](https://catchenlab.life.illinois.edu/stacks/) denovo assembly process. Those are:

#### 'm'
> Minimum number of raw reads required to form a stack, i.e., a putative allele

#### 'M'
> Number of mismatches allowed between stacks, i.e., putative alleles, to merge them into a putative locus

#### 'n'
> Number of mismatches allowed between stacks, i.e., putative loci, during construction of the catalog

For each of these parameters we will iterate over a range of potential values, and then determine the optimal value based on the 'R80' cutoff, i.e., the value that returns the greatest number of polymorphic loci at an 80% completeness threshold. The exact values to iterate over and the designation of this 'R80' cutoff come from the paper [Lost in Parameter Space](https://besjournals.onlinelibrary.wiley.com/doi/10.1111/2041-210X.12775).

Today we will use the [RADStackshelpR](https://github.com/DevonDeRaad/RADstackshelpR) R package to set up our initial optimization runs for the parameter 'm'. The package README includes a link to an example bash script for setting up these optimization runs. If you are struggling with setting up these runs or any of the optimization details, I highly suggest following the README or vignettes (on the pkgdown site) for [RADStackshelpR](https://github.com/DevonDeRaad/RADstackshelpR).

You will need to customize the following script to fit your dataset, and optimize the 'm' parameter. Begin by copying the following into a text editor of your choice:
```
#!/bin/sh
#
#SBATCH --job-name=optimize.m                           #Job Name
#SBATCH --nodes=1                                       #Request number of nodes
#SBATCH --cpus-per-task=15                              #CPU allocation per Task
#SBATCH --partition=bi                                  #Name of the Slurm partition used
#SBATCH --chdir=/home/d669d153/work/phil.dicaeum    	  #Set working directory
#SBATCH --mem-per-cpu=1gb                               #Memory requested
#SBATCH --time=5000                                    #Time requested

files="sample1
sample2
sample3
sample4
sample5"

# Build loci de novo in each sample for the single-end reads only.
# -M — Maximum distance (in nucleotides) allowed between stacks (default 2).
# -m — Minimum depth of coverage required to create a stack (default 3).
#here, we will vary m from 3-7, and leave all other paramaters default

for i in {3..7}
do
#create a directory to hold this unique iteration:
mkdir stacks_m$i
#run ustacks with m equal to the current iteration (3-7) for each sample
id=1
for sample in $files
do
    /home/path/to/stacks-2.41/ustacks -f fastq/${sample}.fq.gz -o stacks_m$i -i $id -m $i -p 15
    let "id+=1"
done
## Run cstacks to compile stacks between samples. Popmap is a file in working directory called 'pipeline_popmap.txt'
/home/d669d153/work/stacks-2.41/cstacks -P stacks_m$i -M pipeline_popmap.txt -p 15
## Run sstacks. Match all samples supplied in the population map against the catalog.
/home/d669d153/work/stacks-2.41/sstacks -P stacks_m$i -M pipeline_popmap.txt -p 15
## Run tsv2bam to transpose the data so it is stored by locus, instead of by sample.
/home/d669d153/work/stacks-2.41/tsv2bam -P stacks_m$i -M pipeline_popmap.txt -t 15
## Run gstacks: build a paired-end contig from the metapopulation data (if paired-reads provided),
## align reads per sample, call variant sites in the population, genotypes in each individual.
/home/d669d153/work/stacks-2.41/gstacks -P stacks_m$i -M pipeline_popmap.txt -t 15
## Run populations completely unfiltered and output unfiltered vcf, for input to the RADstackshelpR package
/home/d669d153/work/stacks-2.41/populations -P stacks_m$i -M pipeline_popmap.txt --vcf -t 15
done
```

Remember your file directory structure should look like:
```
home          (*you are here when you log into the cluster)
  |_work
      |_project.directory
              |_raw.data
              |_fastq
              |_qc
              |_stacks.prelim
```

Things you will need to customize on this script:
1. Customize the header, so that this job runs in your project directory, one level above your 'fastq' directory
2. Customize the sample names assigned to the variable $file. Remember that you want to exclude samples dropped during QC, plus any samples that you are concerned about after looking at your preliminary results.
3. The file 'pipeline_popmap.txt' needs to be inside your project directory (at the same level as your 'fastq' directory), and needs to include the exact same samples that you assigned to the $files variable above, no more, no less.

Now we will follow the same steps as before to move this job script onto the cluster:
> Move into your project directory
```
home
  |_work
      |_project.directory (*you are now here)
              |_raw.data
              |_fastq
              |_qc
              |_stacks.prelim
```

> Open a new, blank text file and call it 'optimize.m.sh', using the following command:
```
vi optimize.m.sh
```

> Follow these steps to paste in the script and save the file
```
*press 'i' to enter insert mode*
*paste in your customized script from your local text editor*
*press 'escape' to exit insert mode*
type ':wq' and hit enter to save and close the file
```

> Now submit your job script and ensure that it begins running:
```
#submit job
sbatch optimize.m.sh
#check your running jobs
squeue -u *your username*
#list the files in your working directory
ls -lh
```

Your file tree should now look like:
```
home  
  |_work
      |_project.directory     (*you are here)
              |_fastq
              |_qc
              |_raw.data
              |_stacks.prelim
              |_stacks_m3
```

You will notice that the directory 'stacks_m3' has been generated within our submit script. This directory will hold all the output files from the first optimization run where 'm' is set = 3. After this run is completed, another directory, named 'stacks_m4', should appear.

Before next week's meeting, your project directory should look like:
```
home  
  |_work
      |_project.directory     (*you are here)
              |_fastq
              |_qc
              |_raw.data
              |_stacks.prelim
              |_stacks_m3
              |_stacks_m4
              |_stacks_m5
              |_stacks_m6
              |_stacks_m7
```
In each of these newly created directories, is a file named 'populations.snps.vcf' which we will use to determine the appropriate 'R80' cutoff for 'm' in your dataset.

### Next Week
Please read the paper [Lost in Parameter Space](https://besjournals.onlinelibrary.wiley.com/doi/10.1111/2041-210X.12775) before our meeting next week, to further familiarize yourself with the importance of optimizing these denovo parameter settings.

