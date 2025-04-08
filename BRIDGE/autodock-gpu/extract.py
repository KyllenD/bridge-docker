#!/usr/bin/env python

from rdkit import Chem
from rdkit.Chem import rdMolAlign
from rdkit.Chem import rdMolDescriptors
from rdkit.Chem import AllChem
from espsim import GetEspSim, GetShapeSim
import argparse,sys
import pandas as pd 
import os
import csv
def parse_command_line(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('--target', help='target molecule', required=True)
    parser.add_argument('--test', help='query molecule', required=True)
    parser.add_argument('--metric', help='similarity metric (tanimoto/carbo)', required=True)
    parser.add_argument('--chargemethod', help='Partial charge distribution to use: Gasteiger (default), mmff, ml, RESP', required=False)
    parser.add_argument('--csv',help='Output csv containing ESP ')
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
test_mol = args.test
met= args.metric
charge=args.chargemethod
csv_in=args.csv

target = [n for n in Chem.SDMolSupplier(target_mol, removeHs=False)]

filename= open(csv_in,'r')
file =csv.DictReader(filename)
ESP_Shape=[]
for col in file:
  ESP_Shape.append(col['ESP_Shape Similarity'])
print(len(ESP_Shape))
topESP_Shape=ESP_Shape[:100]
print(len(topESP_Shape))
split_number=10000
f= "database"
number_of_sdfs = split_number
i=0
j=0
f2=open(test_mol+'_'+str(j)+'_'+'.sdf','w')
for line in open(test_mol):
        f2.write(line)
        if line[:4] == "$$$$":
                i+=1
        if i > number_of_sdfs:
                number_of_sdfs += split_number
                f2.close()
                j+=1
                f2=open(test_mol+'_'+str(j)+'_'+'.sdf','w')

path=os.path.dirname(test_mol)
data=[]

for filename in os.listdir(path):
  if ((filename.endswith("_.sdf")) and (filename.startswith(os.path.basename(test_mol)))):
    data = [m for m in Chem.ForwardSDMolSupplier(os.path.join(path,filename), removeHs=False)]
    for mol in data:
      if mol == None:
         pass  
      else:
         molH=mol
         crip_align(molH,target[0])
         espsim = GetEspSim(molH, target[0], renormalize=True, metric=met, partialCharges=charge)
         shapesim = GetShapeSim(molH, target[0])
         product = espsim * shapesim
         if product in topESP_Shape:
           data.append(mol)

if i==1:
    data = [m for m in Chem.ForwardSDMolSupplier(test_mol, removeHs=False)]
    for mol in data:
      if mol == None:
         pass
      else:
         molH=mol
         crip_align(molH,target[0])
         espsim = GetEspSim(molH, target[0], renormalize=True, metric=met, partialCharges=charge)
         shapesim = GetShapeSim(molH, target[0])
         product = espsim * shapesim
         if product in topESP_Shape:
           data.append(mol)

writer=Chem.SDWriter('extracted.sdf')
writer.write(data)
