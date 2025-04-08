mol new input.gro 
set all [atomselect top "all"]
$all writepdb complex.pdb
quit
