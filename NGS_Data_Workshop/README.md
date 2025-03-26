# SoyaGen Bioinformatics Workshop 2#

What ? A bioinformatics workshop dedicated to the members of the SoyaGen Project.  

When ? From 10h00-12h00, on Tuesday 2017 december 19.

Where ? Workshop will be held at room 1240, Envirotron Building on Laval University campus.


**Subjects covered:**

* GBS data: How to crunch and process data

* Genomics selection

**Instructors: Davoud Torkamaneh and Jerome Laroche**



The informations on this page give whatever steps are necessary to be ready and up and running for the workshop.  

This workshop would not be a repetition of the one gave last year. If you want to review some concepts, you can read the
general [documentation](https://bitbucket.org/jerlar73/ibis_bioinfo) and review what we have done on [workshop 1](https://bitbucket.org/jerlar73/soyagen-bioinformatics-workshop-1)

For most of the section, this workshop will be an introductory to the different components 
of a typical computing system as it is used in most large computing center.  

The main goal of the workshop is to make the SoyaGen scientists comfortable in launching 
analysis on the UNIX server manitou. 


## Things you need to know before attending to the workshop ##

* a good knowledge of the command line system
* a text editor of your choice: pico, nano, joe, vim, etc.


## What do I need to do to be ready for the workshop? ##

* bring your own computer (you can also be in team with someones who have one)
* install some softwares (see next point). No installation will be made the day of the workshop.
* Read this [documentation](https://bitbucket.org/jerlar73/ibis_bioinfo) at least up to the point "Connection softwares"

## How to install the content of this formation? ##

Open a terminal on the computer manitou and type the following command:

```
git clone https://jerlar73@bitbucket.org/jerlar73/soyagen-bioinformatics-workshop-2.git
```

## Exercises ##

### File formats ###

We will start with a review of the main file type widely encountered in bioinformatics that is FASTQ, BAM or SAM and VCF.


Move into the directory containing the files:
```
cd soyagen-bioinformatics-workshop-2/data/seq
```


#### FASTQ sequence file ####

[FASTQ](https://en.wikipedia.org/wiki/FASTQ_format)

Example of an IonTorrent sequence file:  


To see how a fastq file looks:

```
zcat FC20150701_long.fq.gz | head -n 10

@84HY9:01332:11606
AGATCGGAAGAGCGGG
+
XXXYXZTYU[[[ZZZR
@84HY9:01332:11609
TTGGAGGCCAGCGATCTGCTTTTGCATAGACCTGTGGCCATCCTAGCTGTTGTTCTCTCCATATACAAATCCCTGTTTGTTTTGCCCCTCAAAATGTCATTTGGTGCTGAGATCGGAAGAGCGGG
+
POSRRWTYUZZZZYYZZZZZZZOZ[ZYYZZZTZZXYSYTYUWRXXXXYZ[UYYSYYZZZTZ^ZZZ[[ZRZ[[SZ[ZZQYZZZOZ[[[NTUTWWMVVUSVVVOTJMMWWXXXYYZ[V\V\[[[[[R
@84HY9:01332:11617
TCAGACACGATCAGCTCACAGATACGCTTTGTCCTTTTTGCAGAAATGCAGAGGAGGGTGCATCACATTTATTCTTCCATTGCAGAGATCGGAAGAGCGGG
+
KKKPPLMRWWW\^[^Z[][\\[[[[NNN^PXWZTZZZZKZYYZ]^S[\Z\Z[[U[_^S_[\^[[[Z[[[R[[TYZV]V^^V]\\b[Z[[[\V^V[[[XXXM

```

To have the number of sequences:
```
cat FC20150701_short.fq | echo $(($(wc -l)/4))

zcat FC20150701_long.fq.gz | echo $(($(wc -l)/4))
```

To have the sequence length distribution:
```
cat FC20150701_short.fq | sed -n '2~4p' | awk '{print length}' | sort -n | uniq -c | sort -n

zcat FC20150701_long.fq | sed -n '2~4p' | awk '{print length}' | sort -n | uniq -c | sort -n

```

To convert a fastq file to fasta/qual pair of files:
```
module load python/3.5

python3.5

>>> from Bio import SeqIO
>>> SeqIO.convert("FC20150701_short.fq","fastq","FC20150701_short.fasta","fasta")
>>> SeqIO.convert("FC20150701_short.fq","fastq","FC20150701_short.qual","qual")
```

To check the quality of a fastq file with [fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/):
```
module load fastqc/0.11.2

fastqc FC20150701_long.fq.gz

unzip FC20150701_long_fastqc.zip

cd FC20150701_long_fastqc

ls -l

cat fastqc_data.txt | less
```

You can also send the file ```FC20150701_long_fastqc.html``` to your local computer and open it with a web browser.


#### Alignment file: the SAM format ####

After aligning the sequences on the reference genome, we obtain a SAM (Sequence/Alignment Map)
file for each sample. The BAM is the binary version of a SAM file. Usually, we work with the BAM
file because it is smaller and it allows a faster processing.

[SAM](https://davetang.org/wiki/tiki-index.php?page=SAM)

[SAM & BAM format specifications](http://samtools.github.io/hts-specs/SAMv1.pdf)

There are 2 softwares that can manipulate SAM and BAM files: samtools et bamtools.


Load the samtools software:
```
module load samtools/1.3
```

Just type samtools to see the options available:
```
samtools
```

Here we will see how to obtain a BAM file and how to sort and index it before using it with different softwares.

```
samtools view -b -S -h FC20150701_1_BC26.sam -o FC20150701_1_BC26_temp.bam

samtools sort FC20150701_1_BC26_temp.bam -o FC20150701_1_BC26_sort.bam

samtools index FC20150701_1_BC26_sort.bam

```

To get alignment statistics from the sorted bam file:
```
samtools flagstat FC20150701_1_BC26_sort.bam
```

To get the total number of reads:
```
samtools view -c FC20150701_1_BC26_sort.bam
```

To get the total number of mapped reads:
```
samtools view -F4 -c FC20150701_1_BC26_sort.bam
```

To get the total number of unmapped reads:
```
samtools view -f4 -c FC20150701_1_BC26_sort.bam
```

Count the number of reads in the original fastq file (FC20150701_1_BC26.fastq) and compare the result with those obtained from the samtools commands.
Can you explain what's happenned? Hint: look at the file from flagstat


To obtain a new bam file with only the mapped reads:
```
samtools view -b -F 4 FC20150701_1_BC26_sort.bam > FC20150701_1_BC26_sort_mapped.bam
```

To get a fastq file from a bam file
[bedtools](http://bedtools.readthedocs.org/en/latest/content/tools/bamtofastq.html#fq2-creating-two-fastq-files-for-paired-end-sequences)
```
module load bedtools/2.26.0

bedtools bamtofastq -i FC20150701_1_BC26_sort_mapped.bam -fq FC20150701_1_BC26_mapped.fastq
```


#### VCF file ####
Once we have all our BAM files, we use a software for variants discovery and genotyping. There are
a few softwares that do this but here, our preference goes to [platypus](http://www.well.ox.ac.uk/platypus).
The file that is produced by platypus is called a VCF (Variants Call Format) file. The binary
counterpart of a VCF is a BCF file.

Today, we will not see how to obtain a VCF file and we will jump directly to the VCF file manipulations.

[General information on VCF format v4.0](http://www.internationalgenome.org/wiki/Analysis/vcf4.0/)

[VCF file specifications v4.2](http://samtools.github.io/hts-specs/VCFv4.2.pdf)

To manipulate VCF file, one of the best tool is [VCFTOOLS](https://vcftools.github.io/examples.html).
Go here to see [all VCFTOOLS options](https://vcftools.github.io/man_latest.html)

Another very useful software is bcftools. It works transparently with both VCF and BCF,
both uncompressed and BGZF-compressed:
[latest development version](https://samtools.github.io/bcftools/bcftools.html)
[latest versioned release](http://www.htslib.org/doc/bcftools.html)


Before using BEAGLE for imputation, we have to clean up a bit the vcf files we need to work with in the imputation. We do this with VCFTOOLS:
```
cd ../imputation

module load vcftools/0.1.12b

vcftools --vcf wgs_cad_chr10_23samples.vcf --remove-filtered-all --max-missing 0.2 --remove-indels --mac 1 --min-alleles 2 --max-alleles 2 --recode --out wgs_cad_chr10_23samples

vcftools --vcf gbs_cad_chr10_530samples.vcf --remove-filtered-all --max-missing 0.2 --remove-indels --mac 1 --min-alleles 2 --max-alleles 2 --recode --out gbs_cad_chr10_530samples

```

Can you explain the different options used in this command?

You can look at the log files to see how many sites were filtered out.


#### Imputation ####

[Beagle officiel website](https://faculty.washington.edu/browning/beagle/beagle.html)

[Beagle documentation on pdf](https://faculty.washington.edu/browning/beagle/beagle_4.1_21Jan17.pdf)

[Beagle utilities](http://faculty.washington.edu/browning/beagle_utilities/utilities.html)

[An introduction to genotype imputation (conference on YOUTUBE](https://www.youtube.com/watch?v=-oUvXXg6tl8)


Imputation protocol without a reference panel:
```
module load java/jdk/1.8.0_102

java -Xmx25000m -jar /prg/beagle/4.1.0/beagle.jar gt=gbs_cad_chr10_530samples.recode.vcf out=gbs_cad_chr10_530samples_recode_imputed
```

The VCF file will be generated automatically.

**Imputation protocol with a reference file containing phased genotypes obtained via WGS**

Impute missing genotypes in the reference panel:
```
java -Xmx25000m -jar /prg/beagle/4.1.0/beagle.jar gt=wgs_cad_chr10_23samples.recode.vcf out=wgs_cad_chr10_23samples_recode_imputed
```

Impute missing genotypes in the vcf file obtained from GBS:
```
java -Xmx25000m -jar /prg/beagle/4.1.0/beagle.jar ref=wgs_cad_chr10_23samples_recode_imputed.vcf.gz gt=gbs_cad_chr10_530samples.recode.vcf out=gbs_cad_chr10_530samples_recode_imputed_wgs-ref
```

#### Functionnal impacts predicted with snpEFF ####

[SnpEff](http://snpeff.sourceforge.net/SnpEff_manual.html)

To do this analysis, type theses commands:
```
cd $HOME/soyagen-bioinformatics-workshop-2/data

cp -r /project/fbelzile/data/snpEff .

chmod -R u+w snpEff

cd snpEff

cp ../imputation/gbs_cad_chr10_530samples_recode_imputed_wgs-ref.vcf.gz .

java -Xmx10g -jar snpEff.jar -c snpEff.config -v Gmax_275_v2.0 gbs_cad_chr10_530samples_recode_imputed_wgs-ref.vcf.gz > gbs_cad_chr10_530samples_impute_ref.ann.vcf
```
