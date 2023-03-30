#!/usr/bin/env python

from rdkit import Chem
from rdkit.Chem import rdMolAlign
from rdkit.Chem import rdMolDescriptors
from espsim import GetEspSim, GetShapeSim
import argparse,sys,pytest

def parse_command_line(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('--target', help='target molecule', required=True)
    parser.add_argument('--test', help='query molecule', required=True)
    parser.add_argument('--metric', help='similarity metric (tanimoto/carbo)', required=True)
    return parser.parse_args()

def align(prbMol, refMol, prbCrippen=None, refCrippen=None, i=-1, j=-1):
    if prbCrippen is None:
        prbCrippen = rdMolDescriptors._CalcCrippenContribs(prbMol)
    if refCrippen is None:
        refCrippen = rdMolDescriptors._CalcCrippenContribs(refMol)
    alignment = rdMolAlign.GetCrippenO3A(prbMol, refMol, prbCrippen, refCrippen, i, j)
    alignment.Align()
    
args = parse_command_line(sys.argv)

target_mol = args.target
test_mol = args.test
met= args.metric

data = [m for m in Chem.SDMolSupplier(test_mol, removeHs=False)]
target = [n for n in Chem.SDMolSupplier(target_mol, removeHs=False)]
esp=[]
shape=[]
with open('output.txt','w') as f:
  for mol in data:
    align(mol, target[0])
    espsim = GetEspSim(mol, target[0], renormalize=True, metric=met)
    shapesim = GetShapeSim(mol, target[0])
    esp.append(espsim)
    shape.append(shapesim)
    out=(shapesim, espsim)
    f.write(str(out))
  f.close()

maxesp=esp[0]
espindex=0
for i in range(1,len(esp)):
  if esp[i]>= maxesp:
    maxesp = esp[i]
    espindex = i
print (f'Index of molecule with highest ESP similarity is : {espindex}')

maxshape=shape[0]
sh_index=0
for i in range(1,len(shape)):
  if shape[i] >= maxshape:
    maxshape = shape[i]
    sh_index = i
print (f'Index of molecule with highest Shape similarity is : {sh_index}')

writer = Chem.SDWriter('BestESP.sdf')
writer.write(data[espindex])
writer = Chem.SDWriter('BestShape.sdf')
writer.write(data[sh_index])





