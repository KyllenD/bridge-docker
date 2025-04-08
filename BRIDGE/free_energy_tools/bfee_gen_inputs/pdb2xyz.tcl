mol new complex_largeBox.pdb 
set all [atomselect top "all"]
$all writexyz complex_largeBox.xyz
quit
