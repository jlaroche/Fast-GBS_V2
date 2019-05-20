#!/bin/bash

printf "\nMake structure directory: data, barcodes refgenome, results, control_quality\n"
for i in data reject barcodes refgenome results control_quality
do
mkdir $i
done
