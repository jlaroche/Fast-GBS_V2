# Fast-GBS

A bioinformatic pipeline designed to extract a high-quality SNP catalog starting from FASTQ
files obtained from sequencing genotyping-by-sequencing (GBS) libraries. 

## Introduction

Fast-GBS is a bash pipeline facilitating the processing of FASTQ sequence files obtained
using a genotyping-by-sequencing method (GBS). It includes a set of bash commands, python
home-made scripts, and well-known bioinformatics software such as sabre, bwa, samtools and
platypus. Users simply fill out a parameter file and then launch the program.
For each analysis, it requires the existence of a reference genome. This may be a
relatively complete genome made of pseudochromosomes or a more preliminary draft consisting
of scaffolds and contigs.


**Go to the Wiki page to see all the documentation on Fast-GBS!**


## Citing Fast-GBS
Torkamaneh, D., Laroche, J., Bastien, M., Abed, A., & Belzile, F. (2017). Fast-GBS: a new pipeline for the efficient and highly accurate calling of SNPs from genotyping-by-sequencing data. BMC bioinformatics, 18(1), 5. https://doi:10.1186/s12859-016-1431-9

Torkamaneh D, Laroche J, Belzile F (2016) Genome-Wide SNP Calling from Genotyping by Sequencing (GBS) Data: A Comparison of Seven Pipelines and Two Sequencing Technologies. PLoS ONE 11(8): e0161333. https://doi.org/10.1371/journal.pone.0161333

Torkamaneh D, Belzile F (2015) Scanning and Filling: Ultra-Dense SNP Genotyping Combining Genotyping-By-Sequencing, SNP Array and Whole-Genome Resequencing Data. PLoS ONE 10(7): e0131533. https://doi.org/10.1371/journal.pone.0131533

