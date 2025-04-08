#!/usr/bin/env python
import os
from rdkit import Chem
from rdkit.Chem import rdMolAlign
from rdkit.Chem import rdMolDescriptors
import argparse,sys
def parse_command_line(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('--database', help='Database to search', required=True)
    parser.add_argument('--output', help='Database to search', required=True)
    return parser.parse_args()
    
args = parse_command_line(sys.argv)
database = args.database
outfile= args.output

f=open("list.txt","r")
test_mol = f.read().split()
targets = []
done=[]

data = [m for m in  Chem.ForwardSDMolSupplier(database, removeHs=False) if m is not None]
for mol in data:
	if ((str(mol.GetProp("_Name")) in test_mol) and (str(mol.GetProp("_Name")) not in done)):
		targets.append(mol)
	done.append(str(mol.GetProp("_Name")))
      

writer = Chem.SDWriter(outfile)
for i in targets:
	writer.write(i)



