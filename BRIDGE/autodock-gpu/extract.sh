#!/bin/bash
a=$(printf %03d `head RESULTS.txt -n 1 | awk '{print $2}' | sed 's/://' `); cp complexes/complex_dock."$a".pdb topcomplex.pdb; cp ligands/dock."$a".pdb topligand.pdb
