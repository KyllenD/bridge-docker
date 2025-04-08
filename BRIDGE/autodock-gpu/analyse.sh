#!/bin/bash
for j in `ls ligand_*.pdbqt | sed 's/.pdbqt//'`; do mv "$j".xml `grep "REMARK TITLE" "$j".pdbqt | awk '{print $3}'`.xml; mv "$j".dlg `grep "REMARK TITLE" "$j".pdbqt | awk '{print $3}'`.dlg; done

for j in `ls *.xml | sed 's/.xml//g'`; do echo $j ; grep -A2 '<runs>' "$j".xml;done > SUMMARY
bash rearrange.sh | sort -k 3 -n >> RESULTS.txt
sed -i '1i Name,Pose,Docking Score (kcal/mol)' RESULTS.txt 
for j in *.dlg; do bash dlgtopdb.sh $j;done
for j in *.pdb; do a=$(grep COMPND $j | awk '{print $2}' | awk -F . -v OFS="." 'NF-=2'); b=$(grep MODEL $j| awk '{print $2}'); sed -i "1 i\REMARK TITLE POSE $a $b" $j ;done
cat *.pdb > docked_poses.pdb
#a=$(grep "Estimated Free Energy of Binding" $1 | awk '{print $9}'| wc -l); for j in `seq 1 $a`; do echo Pose $j: `grep "Estimated Free Energy of Binding" $1 | awk '{print $9}' | sed -n "$j"p` kcal/mol;done | sort  -n -k 3 >> RESULTS.txt
