#!/bin/bash
a=$1;b=$(($a + 1));for j in `head -n $b sorted.csv | sed '1d' | sort -u |awk -F , '{print $1}'` ; do echo -n $j" " ;done|  rev | cut -c2- | rev >> list.txt
#for j in `cat list.txt`; do 
#sed -ne "/$j\\b/,/\$\$\$\$/{/\$$$$/!p;/\$\$\$\$/q}" database.sdf >> Extracted.sdf
#done
