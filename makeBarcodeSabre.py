#!/usr/bin/python

"""
The barcode file was not found!

Give a valid flowcell and lane specification.

Check the name given to the barcode file is in accord with the name of sequence file.

Usage:
    ./makeBarcodeSabre.py <flowcell> <lane> <seqtype>
"""

import os, sys, fileinput
import sys

try:
	f = open('barcodes_'+sys.argv[1]+'_'+sys.argv[2],'r')
except:
	print(__doc__)
	sys.exit(1)

try:
	seqtype=sys.argv[3]
except:
	print('Specify a sequence type: SE or PE')
	sys.exit(1)

if seqtype=='SE':
	o = open(flow+'_'+lane+'_SE','w')
	line = f.readline()
	while line:
		list = line.split()
		o.write(list[0]+' '+flow+'_'+lane+'_'+list[1]+'.fq\n')
		line = f.readline()
	f.close()
	o.close()

if seqtype=='PE':
	o = open(flow+'_'+lane+'_PE','w')
	line = f.readline()
	while line:
		list = line.split()
		o.write(list[0]+' '+flow+'_'+lane+'_'+list[1]+'_R1.fq'+' '+flow+'_'+lane+'_'+list[1]+'_R2.fq\n')
		line = f.readline()
	f.close()
	o.close()
