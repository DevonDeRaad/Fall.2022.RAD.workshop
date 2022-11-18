# Optimizing denovo Stacks assembly parameter 'M'
### Last week:
Last week we ran five [Stacks](https://catchenlab.life.illinois.edu/stacks/) iterations varying the 'm' parameter from 3-7. 

### This week:
We will see which value is optimal for our dataset according to the 'R80' cutoff.

#### Navigate to your project directory on the cluster
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

Now move each of the vcf files containing your SNP data into the project directory by copying and pasting the following code into your terminal:
```
cp stacks_m3/populations.snps.vcf ./m3.vcf
cp stacks_m4/populations.snps.vcf ./m4.vcf
cp stacks_m5/populations.snps.vcf ./m5.vcf
cp stacks_m6/populations.snps.vcf ./m6.vcf
cp stacks_m7/populations.snps.vcf ./m7.vcf
```

Now copy these vcf files into your project directory on your local machine using a command like the following:
```
scp -r username@hpc.crc.ku.edu:/home/username/work/project.directory/*.vcf /Users/username/Desktop/project.directory/
```

Now we will use commands from the [RADStackshelpR](https://github.com/DevonDeRaad/RADstackshelpR) to simply determine what the optimal 'm' value is for our dataset. To begin, open Rstudio, and in the header tab select file > new file > Rmarkdown. In your new Rmarkdown file, add your name as author, and give this analysis an informative title, in my case, 'Parameter optimization for denovo Stacks assembly of Philippines Dicaeum RAD data'. Now delete all of the generic recommended text, i.e., lines 8 and below. In it's place, copy the following code:
~~~
### Install and load packages
```{r}
install.packages("RADstackshelpR")
library(RADstackshelpR)
```

### Optimize 'm'
```{r}
#optimize_m function will generate summary stats on your 5 iterative runs
#input can be full path to each file, or just the file name if the vcf files are in your working directory
m.out<-optimize_m(m3="/Users/username/Desktop/philippines.rad/m3.vcf",
           m4="/Users/username/Desktop/philippines.rad/m4.vcf",
           m5="/Users/username/Desktop/philippines.rad/m5.vcf",
           m6="/Users/username/Desktop/philippines.rad/m6.vcf",
           m7="/Users/username/Desktop/philippines.rad/m7.vcf")
           
#visualize depth of coverage
vis_depth(output = m.out)

#visualize the effect of varying m on the number of SNPs retained
vis_snps(output = m.out, stacks_param = "m")

#visualize the effect of varying m on the number of loci retained
vis_loci(output = m.out, stacks_param = "m")
```
~~~

You will only need to customize the full path specifying where on your local machine your output vcf files from Stacks reside.

You should end up with an image like this:

![example 'm' optimization](https://github.com/DevonDeRaad/RADstackshelpR/blob/master/man/figures/unnamed-chunk-5-3.png)

The red asterisk here lets you know that the optimal 'm' value for this dataset is 3.

Now we will start optimizing 'M', this time by running 8 iterations (M=1:8), while setting 'm' to its optimized value. Begin by copying the following into your text editor:
```
#!/bin/sh
#
#SBATCH --job-name=optimize.M                           #Job Name
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

for i in {1..8}
do
#create a directory to hold this unique iteration:
mkdir stacks_bigM$i
#run ustacks with m equal to the optimized value, and 
id=1
for sample in $files
do
    /home/d669d153/work/stacks-2.41/ustacks -f fastq/${sample}.fq.gz -o stacks_bigM$i -i $id -m X -M $i -p 15
    let "id+=1"
done
## Run cstacks to compile stacks between samples. Popmap is a file in working directory called 'pipeline_popmap.txt'
/home/d669d153/work/stacks-2.41/cstacks -P stacks_bigM$i -M pipeline_popmap.txt -p 15
## Run sstacks. Match all samples supplied in the population map against the catalog.
/home/d669d153/work/stacks-2.41/sstacks -P stacks_bigM$i -M pipeline_popmap.txt -p 15
## Run tsv2bam to transpose the data so it is stored by locus, instead of by sample.
/home/d669d153/work/stacks-2.41/tsv2bam -P stacks_bigM$i -M pipeline_popmap.txt -t 15
## Run gstacks: build a paired-end contig from the metapopulation data (if paired-reads provided),
## align reads per sample, call variant sites in the population, genotypes in each individual.
/home/d669d153/work/stacks-2.41/gstacks -P stacks_bigM$i -M pipeline_popmap.txt -t 15
## Run populations completely unfiltered and output unfiltered vcf, for input to the RADstackshelpR package
/home/d669d153/work/stacks-2.41/populations -P stacks_bigM$i -M pipeline_popmap.txt --vcf -t 15
done
```

Things you will need to customize on this script:
1. Customize the header, so that this job runs in your project directory, one level above your 'fastq' directory
2. Customize the sample names assigned to the variable $file. I suggest simply copying and pasting your list of samples from last week (the included samples should not change between optimization steps).
3. The value of 'm' needs to be set equal to the optimal value that you determined using the RADstackshelpR package.

### Note
> The file 'pipeline_popmap.txt' should already be inside your project directory from optimizing 'm' last week, and should not need to be modified.

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
              |_stacks_m3
              |_stacks_m4
              |_stacks_m5
              |_stacks_m6
              |_stacks_m7
```

> Open a new, blank text file and call it 'optimize.bigM.sh', using the following command:
```
vi optimize.bigM.sh
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
sbatch optimize.bigM.sh
#check your running jobs
squeue -u *your username*
#list the files in your working directory
ls -lh
```
