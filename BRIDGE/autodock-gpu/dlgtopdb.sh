location=$1
name=$(echo $1 |sed 's/.dlg//')
grep '^DOCKED' $location | cut -c9- > dock.pdbqt
a=$(grep ENDMDL dock.pdbqt | wc -l)
b=$((a - 2))
csplit -k -s -n 3 -f $name. dock.pdbqt '/^ENDMDL/+1' '{'$b'}'
#read -p "Enter location of macromolecule: " receptor
for f in "$name".[0-9][0-9][0-9]
do
  mv $f $f.pdbqt
  /cchem/galaxy/var/dependencies/_conda/envs/__openbabel@2.4.1/bin/obabel $f.pdbqt -O $f.pdb
  rm $f.pdbqt
done
rm dock.pdbqt
#rm my_docking.pdbqt dock.pdbqt
