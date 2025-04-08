#!/bin/bash
for j in `cat list.txt`; do 
sed -ne "/$j\\b/,/\$\$\$\$/{/\$$$$/!p;/\$\$\$\$/q}" database.sdf >> Extracted.sdf
done
