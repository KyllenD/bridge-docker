#!/bin/bash
#Usage: bash namd2amber.sh pdbfile psffile strfile ligandresname

(echo chamber -crd $1 -psf $2 -toppar toppar/\* -toppar $3 -radii mbondi; echo outparm solvated_complex.parm7 solvated_complex.rst7 ; echo quit) |parmed; 
(echo parm solvated_complex.parm7 ; echo strip :WAT,CLA,POT,SOD,TIP3; echo outparm complex.parm7;echo quit) | parmed;
(echo parm solvated_complex.parm7;echo strip :"$4",WAT,CLA,POT,SOD,TIP3 ; echo outparm receptor.parm7;echo quit) | parmed;
(echo parm solvated_complex.parm7;echo strip \!:"$4" ; echo outparm ligand.parm7;echo quit) | parmed; 


