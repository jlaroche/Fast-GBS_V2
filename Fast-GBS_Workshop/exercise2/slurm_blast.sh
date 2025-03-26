#!/bin/bash

#SBATCH -D /home/
#SBATCH -J blast_trinity
#SBATCH -o blast_trinity-%j.out
#SBATCH -c 4
#SBATCH -p soyagen
#SBATCH -A soyagen
#SBATCH --mail-type=ALL
#SBATCH --mail-user=MY_EMAIL
#SBATCH --time=2-1:00:00
#SBATCH --mem=10240

module load ncbiblast/2.2.29

nt="/biodata/blastdb/nt"

# Options to be used with outport format 1 (default):
# -num_descriptions 3
# -num_alignments 3 

blastn -db $nt -query Trinity.fasta -num_threads 4 -max_target_seqs 1 -evalue 1e-5 -out Trinity_vs_nt_fmt7.out -outfmt 7 
