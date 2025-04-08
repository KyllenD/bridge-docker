sed -i '/cellBasisVector/d' ./007.1_eq.conf;
c=$(grep CRYST1 complex_largeBox.pdb | awk '{print $4}') ; sed -i "/temperature/a CellBasisVector3 0 0 $c" 007.1_eq.conf;
b=$(grep CRYST1 complex_largeBox.pdb | awk '{print $3}') ; sed -i "/temperature/a CellBasisVector2 0 $b 0" 007.1_eq.conf;
a=$(grep CRYST1 complex_largeBox.pdb | awk '{print $2}') ; sed -i "/temperature/a CellBasisVector1 $a 0 0" 007.1_eq.conf
