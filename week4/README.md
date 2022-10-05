# Running the Stacks pipeline
### Last week
> After running [fastqcR](https://rpkgs.datanovia.com/fastqcr/index.html) on our demultiplexed sample files last week, we should now have a feeling for the distribution of raw reads among our sequenced samples, and a .html document that can be accessed at any time to review this quality information. Saving our code and these output documents is key for reproducibility and transparency once we are ready to put our projects out into the world. For now, I will save my .html output file in a stable directory on my local computer and follow the recommended (arbitrary) cutoff threshold for removing low data samples (see below)
insert screenshot
### Today:
> Today we will be using the quality control information to remove bad apples immediately, and perform a preliminary Stacks run.
*remember* our file tree currently looks like:
```
home  
  |_work
      |_project.directory
              |_fastq
              |_qc
```
### Step 1:
> Move into your project directory and make a new subdirectory (i.e., folder) to hold this preliminary run, e.g.:
```
cd work/project.directory
mkdir stacks.prelim
```
Our file tree should now look like:
```
home  
  |_work
      |_project.directory
              |_fastq
              |_qc
              |_stacks.prelim
```
### Step 2:
> Move into this newly made directory, e.g.:
```
cd stacks.prelim

```

