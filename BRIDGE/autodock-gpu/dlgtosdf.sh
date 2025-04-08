#read -p "Enter location of dlg file: " location
location=$1
#grep '^DOCKED' $location | cut -c9- > my_docking.pdbqt
#cut -c-66 my_docking.pdbqt > dock.pdbqt
grep '^DOCKED' $location | cut -c9- > dock.pdbqt
a=$(grep ENDMDL dock.pdbqt | wc -l)
b=$((a - 2))
csplit -k -s -n 3 -f dock. dock.pdbqt '/^ENDMDL/+1' '{'$b'}'
#read -p "Enter location of macromolecule: " receptor
for f in dock.[0-9][0-9][0-9]
do
  mv $f $f.pdbqt
#  cat $receptor $f.pdb | grep -v '^END   ' | grep -v '^END$' > complex$f.pdb
  obabel $f.pdbqt -O $f.sdf
done
rm dock.pdbqt
#rm my_docking.pdbqt dock.pdbqt
