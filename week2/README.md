# Week 2 - demultiplexing

This week, we will focus on demultiplexing our illumina reads into separate files for each sample using the unique sample barcodes. We will begin by discussing the paper [Harnessing the power of RADseq for ecological and evolutionary genomics](https://github.com/DevonDeRaad/Fall.2022.RAD.workshop/blob/main/key.reading/nrg.2015.28.pdf), which gives us a nice introduction to what RADseq is and why we do it. We will go over the details of indexing and pooling, to give us a conceptual base to understand the process of demultiplexing.

Following our discussion, we will go over how to use the Stacks function [process_radtags](https://catchenlab.life.illinois.edu/stacks/comp/process_radtags.php) to assign sequence data into sample files based on the unique indexes associated with each sample. We will start by creating a barcode file that specifies each sample barcode for our given project in the necessary format for process_radtags.

Then, we will go over the details of how to format a submission script to run a job remotely on the KU cluster. There is already an excellent tutorial to get you started [here](https://crc.ku.edu/hpc/how-to#script).

The goal for this week is to leave with your demultiplex job running, so that next week you will be ready to start analyzing your individual samples.

Homework for this week is to read the stacks webpages (maybe paper? add link) and get as familiar as possible with the pipeline we will be implementing next week.
