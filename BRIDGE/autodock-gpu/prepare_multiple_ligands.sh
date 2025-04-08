obabel ligand.mol2 -O ligand.mol2 -m 
for j in `ls ligand*.mol2 | sed 's/.mol2//'`; do 
prepare_ligand4.py -l "$j".mol2 -v  -U $1; a=$(grep -A 1 '@<TRIPOS>MOLECULE' "$j".mol2 | tail -n1); sed -i "1iREMARK TITLE $a" "$j".pdbqt; done
