mol new solv.gro 
set all [atomselect top "all"]
$all writepdb complex_largeBox.pdb
quit
