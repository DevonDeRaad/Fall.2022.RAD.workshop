# Week 2 - demultiplexing

### Step 1:
> Reinforcing what we learned last week, we will each create a directory on the KU cluster to hold our project, and copy in the raw sequence data.

### Step 2:
> While files are copying, we will have a discussion on the paper [Harnessing the power of RADseq for ecological and evolutionary genomics](https://github.com/DevonDeRaad/Fall.2022.RAD.workshop/blob/main/key.reading/nrg.2015.28.pdf), which gives us a nice introduction to what RADseq is and why we do it. We will go over the details of indexing and pooling, to give us a conceptual base to understand the process of demultiplexing.

### Step 3:
> Following our discussion, we will go over how to use the Stacks function [process_radtags](https://catchenlab.life.illinois.edu/stacks/comp/process_radtags.php) to assign raw sequence data into sample files based on the unique indexes associated with each sample. We will go through the [Stacks manual](https://catchenlab.life.illinois.edu/stacks/manual/) up to section 4.2, to guide ourselves through the demultiplexing process.

### Step 4:
> Then, we will go over the details of how to format a submission script to run a job remotely on the KU cluster. There is already an excellent tutorial to get you started [here](https://crc.ku.edu/hpc/how-to#script).

### Takeaways:
> The goal for this week is to leave with your demultiplex job running, so that next week you will be ready to start running your individual samples through the Stacks pipeline. A tutorial detailing the steps we learned to demultiplex our data (single-end, single-barcode reads) on the KUHPCC today, is available [here]().

### Next week:
> Homework for next week is to read the [Stacks manual](https://catchenlab.life.illinois.edu/stacks/manual/) to get as familiar as possible with the pipeline we will be implementing next week. Please spend as much time as you can familiarizing yourself with this pipeline, understanding it will be key to working with your RAD datasets!
