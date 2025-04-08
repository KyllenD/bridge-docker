#!/bin/bash
#export LD_LIBRARY_PATH='/usr/local/cuda-11.7/lib64'
python3 split_pdbqt.py 2>&1 
for j in ligand_*.pdbqt; do 
./autodock_gpu_128wi --lfile "$j" --ffile receptor.maps.fld --nrun $1 --seed 160210; done
