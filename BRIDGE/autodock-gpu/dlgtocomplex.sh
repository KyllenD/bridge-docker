#read -p "Enter location of dlg file: " location
#grep '^DOCKED' $location | cut -c9- > my_docking.pdbqt
#cut -c-66 my_docking.pdbqt > dock.pdbqt
#grep '^DOCKED' $location | cut -c9- > dock.pdbqt
#a=$(grep ENDMDL dock.pdbqt | wc -l)
#b=$((a - 2))
#csplit -k -s -n 3 -f dock. dock.pdbqt '/^ENDMDL/+1' '{'$b'}'
#read -p "Enter location of macromolecule: " receptor
for f in dock.[0-9][0-9][0-9].pdb
do
  cat $1 $f | grep -v '^END   ' | grep -v '^END$' > complex_$f
done

