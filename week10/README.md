# Write out a detailed methods section documenting your progress
### Last week:
Last week we filtered our denovo optimized SNP dataset using the SNPfiltR package. 

### This week:
We are going to write out the details of all steps that we performed before we forget them.

### Structure
I suggest having multiple subheadings in your methods section, so that readers can follow the flow of what you have done. For example:

### DNA extraction, library preparation, and sequencing
Details on your DNA extraction protocol, library prep protocol, and how/where you sequenced your samples. For folks in our working group, you will probably want to say something like
> "For DNA extraction from vouchered tissue samples, we used a manual magnetic bead-based protocol (full protocol available at: https://github.com/DevonDeRaad/todiramphus.radseq/blob/main/lab.protocols/DNA.extraction.protocol.txt) based on Rohland & Reich (2012).

For library prep, something like
> "Library prep was performed at the University of Kansas Genomic Sequencing Core, following the protocol outlined in Manthey and Moyle (2015). Full protocol available at: (https://github.com/DevonDeRaad/todiramphus.radseq/blob/main/lab.protocols/MSG.library.prep.protocol.md). Samples were digested with the enzyme NdeI, ligated with custom barcodes, size selected for fragments between 500-600 base pairs in length, PCR amplified, and bead purified."

For sequencing you will want to have details like
> "Libraries were pooled across projects and sequenced on a single flow cell on a NextSeq550 Illumina sequencing machine at the KU Genomic Sequenciong Core, using the high-output option to generate single-end 100bp reads."

### De novo assembly
You will want to include details of the parameter optimization protocol that you followed, stating the specific optimized parameter values for your dataset. For instance "We varied three Stacks parameters crucial for denovo assembly of RAD loci following the recommendations of Paris et. al (2017). Specifically, we varied m from 3-7, M from 1-8, and n from M-1, M, and M+1, each time choosing the optimal value based on the 'R80' cutoff (i.e., the parameter value that results in the greatest number of polymorphic loci reaching an 80% completeness threshold)."

### Qaulity filtering
You will want to detail the individual choices that you made in quality filtering your optimized SNP dataset. In particular, you will want to include the thresholds you set for minimum per gentoype depth of coverage, genotype quality, per SNP maximum depth, allele balance, per sample completeness, per SNP completeness, and minor allele count. Make sure you report the number of individual samples and SNPs you retained in your filtered SNP dataset, and your distance thinned (1 SNP per locus) dataset.

### Note
> Don't forget to paraphrase and avoid copying strings of words exactly in your writing (even in technical sections like the methods) in order to avoid unintentional plagiarism. There are many websites (e.g., https://quillbot.com/) that can help you with this task.
