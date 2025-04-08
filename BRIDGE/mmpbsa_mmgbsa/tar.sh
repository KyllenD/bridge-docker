#!/bin/bash
tar xf $1
mv final/* .
rm step4_equilibration.dcd step5_production.dcd
for j in `echo *.dcd | sed 's/.dcd//g'`;
do
bash namd2amber.sh "$j".pdb "$j".psf "$j".str UNL &&
MMPBSA.py -O -i mmgbsa.in -sp solvated_complex.parm7 -cp complex.parm7 -rp receptor.parm7 -lp ligand.parm7 -y "$j".dcd -o "$j"_FINAL_MMGBSA_RESULTS 2>&1
echo "$j" `grep 'DELTA TOTAL' "$j"_FINAL_MMGBSA_RESULTS | awk '{print $3,$4}'` >> MM_SCORES
rm solvated_complex.parm7 solvated_complex.rst7 complex.parm7 receptor.parm7 ligand.parm7
done
