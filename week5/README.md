# Preliminary pop-gen analyses
### Last week:
> Last week we ran the Stacks pipeline for denovo assemble, align, and call SNPs from our RAD loci. As a refresher, this process is detailed in the following diagram:
![img](stacks.diagram.png "Title")

> For our final step, we used the Stacks 'populations' module to output all called SNPs as a completely unfiltered variant call format (VCF) file using the following syntax:
```
## Run populations completely unfiltered and output unfiltered vcf, we will do filtering using the SNPfiltR package
/home/d669d153/work/stacks-2.41/populations -P stacks.prelim -M pipeline_popmap.txt --vcf -t 15
```
This should have resulted in the creation of a file named 'populations.snps.vcf' in the directory named 'stacks.prelim'. If you don't see this file, look through the error messages output by Stacks in your slurm output file, and rerun any steps in the Stacks pipeline that failed, until you see the file 'populations.snps.vcf'.

### This week:
> We will check out the results from our preliminary Stacks run right away. Start by copying your VCF file from the cluster to your local machine, using a command like (you will need to modify paths to match your own directory structures):
```
scp -r d669d153@hpc.crc.ku.edu:/home/d669d153/work/cluster.project.directory/populations.snps.vcf /Users/devder/Desktop/local.project.directory/
```
