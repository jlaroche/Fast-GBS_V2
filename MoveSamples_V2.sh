#!/bin/bash

cd stat

#Variable that count the total number of reads
t=0
#Variable that count the total number of samples
c=0
#Parsing the file containing the number of reads per sample
cat stat_fq.txt | ( while read line
do
	id=$(echo $line | cut -d' ' -f1)
	nbseq=$(echo $line | cut -d' ' -f2)

	t=$(( $nbseq + t ))
	c=$(( c + 1 ))
done

#Compute the average number of reads from the sample pool
m=$((t / c))
echo "The average number of reads is: " $m

#Compute 10% of the average
a=`bc <<< "scale=0; $m*0.1"`
#Round to integer the preceeding number
gf=$(echo "$a" | awk '{printf("%d\n",$1 + 0.5)}')

echo "10% of the average is: " $gf

cat stat_fq.txt | ( while read line
do
	id=$(echo $line | cut -d' ' -f1)
	nbseq=$(echo $line | cut -d' ' -f2)
	
	test=""
	if [ "$gf" -gt "$nbseq" ]
		then test="Remove this sample from the analysis"
		mv ../samples/$id ../reject/
	fi
	
	echo $id $nbseq $gf $test
done

)
)
