#/usr/bin/env python

from rdkit import Chem
from rdkit.Chem import rdMolAlign
from rdkit.Chem import rdMolDescriptors
from rdkit.Chem import AllChem
from espsim import GetEspSim, GetShapeSim, EmbedAlignScore
import argparse,sys
import pandas as pd 
import os
import ssl
ssl._create_default_https_context = ssl._create_unverified_context

def parse_command_line(argv):
	parser = argparse.ArgumentParser()
	parser.add_argument('--target', help='target molecule', required=True)
	parser.add_argument('--metric', help='similarity metric (tanimoto/carbo)', required=True)
	parser.add_argument('--chargemethod', help='Partial charge distribution to use: Gasteiger (default), mmff, ml, RESP', required=False)
	parser.add_argument('--sort', help='sort output by (ESP/Shape/ESP*Shape similarity)', required=True)
	parser.add_argument('--sanitize', help='sanitize input or not', required=False)
	parser.add_argument('--outfile', help='galaxy_ouput', required=False)
	return parser.parse_args()

def crip_align(prbMol, refMol, prbCrippen=None, refCrippen=None, i=-1, j=-1):
	if prbCrippen is None:
		prbCrippen = rdMolDescriptors._CalcCrippenContribs(prbMol)
	if refCrippen is None:
		refCrippen = rdMolDescriptors._CalcCrippenContribs(refMol)
	alignment = rdMolAlign.GetCrippenO3A(prbMol, refMol, prbCrippen, refCrippen, i, j)
	alignment.Align()
    
args = parse_command_line(sys.argv)

target_mol = args.target
test_mol=args.target
met= args.metric
charge=args.chargemethod
sortby=str(args.sort) 
san_opt=bool(args.sanitize)
outfile=args.outfile


if sortby=="ESP":
	sortk=2
elif sortby=="Shape":
	sortk=3
else:
	sortk=4

data = [m for m in  Chem.ForwardSDMolSupplier(target_mol, removeHs=False) if m is not None]

for mol in data:
	if mol == None:
		pass
	else:
		crip_align(mol,data[0])
		espsim = GetEspSim(mol, data[0], renormalize=True, metric=met, partialCharges=charge)
		shapesim = GetShapeSim(mol, data[0])
		product = espsim * shapesim
		name=mol.GetProp("_Name")
		os.system("echo {0},{1},{2},{3} >> {4}".format(name,espsim,shapesim,product,outfile))

os.system("cat {0} | sed '/nan/d' | sort -g -k {1} -t , -r > sorted.csv".format(outfile,sortk))
os.system("sed -i '1s/^/Name,ESP Similarity,Shape Similarity,ESP_Shape Similarity\\n/' sorted.csv")
	
