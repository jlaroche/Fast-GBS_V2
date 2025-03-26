# SoyaGen Bioinformatics Workshop 1#

This is a private workshop dedicated to the members of the SoyaGen Project.  

The workshop will be held at IBIS, Marchand Building on Laval University campus from 13h00-15h30 on 2016 december 2.

The informations on this page give whatever steps are necessary to be ready and up and running for the workshop.  

For most of the section, this workshop will be an introductory to the different components 
of a typical computing system as it is used in most large computing center.  

The main goal of the workshop is to make the SoyaGen scientists comfortable in launching 
analysis on the UNIX server manitou. 


### Workshop Content ###

* Connection to a UNIX server and useful commands
* text editors
* the computer manitou
* file system
* module system
* slurm system
* bioinformatics softwares
* bitbucket
* ressources dedicated to SoyaGen
* launching an analysis


### What do I need to do to be ready for the workshop? ###

* bring your own computer (you can also be in team with someones who have one)
* install some softwares (see next point). No installation will be made the day of the workshop.
* Read this [documentation](https://bitbucket.org/jerlar73/ibis_bioinfo) at least up to the point "Connection softwares"


### Exercises ###

Start a local terminal window with the application you have installed on your computer: MobaXterm, Terminal, etc.  

Connect to gate:  

```ssh -Y <your_login>@gate.ibis.ulaval.ca```

Once on gate, connect to manitou:  

```ssh -Y <your_login>@manitou.ibis.ulaval.ca```

Once you are connected to manitou, take a few minutes to explore the server by typing these commands: 
(do not type lines beginning with #)
```

cd /

ls

#Where the softwares are installed:
cd /prg

ls

#To see the softwares available through module:
module avail

#Where general databases are installed:
cd /biodata

ls

#The SoyaGen directory:
cd /project/fbelzile

ls -l

#Where the account are:
cd users

#Data to be shared between users:
cd ../data

#Some specific scripts:
cd ../prg

#Reference genomes for mapping reads:
cd ../genome_ref

```

If you are lost, type the command ```pwd``` to see where you are.  
Type ```cd``` to return to your home.


Type a few SLURM commands:  

```
squeue -u <login>

sacctmgr list qos format="Name,MaxWall,MaxTRESPerUser%20,GrpTRES"

sacctmgr list association format="Account,User" where User=<login>

```

Type the command ```top``` to see all the jobs running on manitou and the resources they require.  

Type these few basic UNIX commands:  

```
whoami

who

man grep
```


When it's done, install the exercises.  
In your home directory, enter the command:
```git clone --recursive https://jerlar73@bitbucket.org/jerlar73/soyagen-bioinformatics-workshop.git```

## Exercise 1: running Fast-GBS pipeline ##
For this exercise, clone the Fast-GBS pipeline and prepare sub-folder directories:  

```
cd soyagen-bioinformatics-workshop/exercise1

git clone https://jerlar73@bitbucket.org/jerlar73/fast-gbs.git

cd fast-gbs

./makeDir.sh

ls -l
```

Move the fastq and the barcodes files:  

```
cd ..

mv FC20150701_1.fq.gz fast-gbs/data

mv barcodes_FC20150701_1 fast-gbs/barcodes
```

Create symbolic link to reference genome:  

```
cd fast-gbs/refgenome

for i in $(ls -1 /project/fbelzile/genome_ref/Gmax_275_v2.0.fa*);do ln -s $i;done

ls -l

cd ..
```

Edit SLURM_GBS.sh with the text editor joe:  

```
joe SLURM_GBS.sh
```
 
* Copy-paste the results of the command ```pwd``` at the line beginning with ```#SBATCH -D```  
* Add your email adress at the line ``--mail-user```  

Edit the file parameters.txt with the text editor joe:  

```
joe parameters.txt
```
 
* Enter the correct fastq and barcode file names.   
* Modify the TECHNOLOGY: IONTORRENT

Submit your job to SLURM with the command:  

```sbatch SLURM_GBS.sh```

Check the status of your job with the commands:  

```
top

```

Filter the vcf file in the interactive mode:  

```
srun --pty bash

cd results

module load vcftools/0.1.12b

vcftools --vcf FastGBS_platypus.vcf --remove-filtered-all --remove-indels --min-alleles 2 --max-alleles 2 --mac 1 --recode --out FastGBS_platypus_biSNP

grep -v scaffold FastGBS_platypus_biSNP.recode.vcf > FastGBS_platypus_biSNP_chr.recode.vcf

exit

```

## Exercise 2: Impute missing genotypes with Beagle ##

After For this exercise, take the final vcf file from the preceding exercise and launch the script ImputeBeagle.sh on it.  

```
cd results

../ImputeBeagle.sh FastGBS_platypus_biSNP_chr.recode.vcf

```

Inspect the final vcf file.

## Exercise 3: Produce vcf file summary and plink files with TASSEL5 ##

```
srun --pty bash

cd results

module load java/jdk/1.8.0_73

module load tassel/5.0

run_pipeline.pl -Xms8g -Xmx10g -fork1 -vcf ImputeFile.FastGBS_platypus_biSNP_chr.recode.recode.bgl.gz.phased_new.vcf -genotypeSummary taxa -export GenoSum_mac1geno80_taxa -runfork1

run_pipeline.pl -Xms8g -Xmx10g -fork1 -vcf ImputeFile.FastGBS_platypus_biSNP_chr.recode.recode.bgl.gz.phased_new.vcf -export soybean -exportType Plink -runfork1

exit

```

If you want, you can repeat the command of vcftools, grep, tassel5 and imputation on a more realistic vcf file. Grab this file with this command:

```
cd results

cp /scratch/soyagen_workshop/soybean_gbs.vcf .

```

and proceed with the same commands seen earlier. You just to replace the input and output file names.  



## Exercise 4: Launch a blast search ##

BLAST is one of the most bioinformatics alogorithm used. In this exercise, we will see how to use BLAST to do a research on GenBank nt database.  
Go to exercise2.  

```
joe slurm_blast.sh

sbatch slurm_blast.sh

```

