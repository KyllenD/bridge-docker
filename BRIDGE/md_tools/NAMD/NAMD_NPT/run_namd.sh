#!/bin/sh

# _________ read inputs from the galaxy wrapper ____________ 

psfin=$1 
pdbin=$2
pmeshspec=$3
structureprm=$4
temp=$5
pressure=$6
restart=$7
coor=$8
vel=$9
xsc=${10}
restraints=${11}
bbrmsd=${12}
scrmsd=${13}
subsrmsd=${14}
bb=${15}
sc=${16}
subs=${17}
extrain=${18}
par=${19}
dcd_freq=${20}
freq=$(($dcd_freq * 1000))
simulation_time=${21}
steps=$(($simulation_time * 1000))
nproc=${22}
coorout=${23}
velout=${24}
xscout=${25}
dcdout=${26}
output=${27} 
tooldir=${28} 

ln -s "${tooldir}/../../force_fields/namd" ffields    
ffields="${tooldir}/../../force_fields/namd"   

# ________ create the source file ______

sourcefile=./variables.str   
echo "#sourcefile file for inputs" > $sourcefile
echo "                   " >> $sourcefile
echo "                    " >> $sourcefile
echo "set psfin  \"$psfin\"" >> $sourcefile
echo "set pdbin  \"$pdbin\"" >> $sourcefile
echo "set pmeshspec  \"$pmeshspec\"" >> $sourcefile
echo "set structureprm  \"$structureprm\"" >> $sourcefile 
echo "set ffields \"$ffields\"" >> $sourcefile  
echo "set coor  \"$coor\"" >> $sourcefile   
echo "set vel  \"$vel\"" >> $sourcefile   
echo "set xsc  \"$xsc\"" >> $sourcefile
echo "set bbrmsd  \"$bbrmsd\"" >> $sourcefile 
echo "set scrmsd  \"$scrmsd\"" >> $sourcefile 
echo "set subsrmsd  \"$subsrmsd\"" >> $sourcefile    
echo "set toppar  \"$toppar\"" >> $sourcefile
echo "set coorout  \"$coorout\"" >> $sourcefile
echo "set velout  \"$velout\"" >> $sourcefile
echo "set xscout  \"$xscout\"" >> $sourcefile
echo "set dcdout  \"$dcdout\"" >> $sourcefile
echo "                    " >> $sourcefile

tr "[:upper:]" "[:lower:]" < $structureprm | sed -e "s/ =//g" > ./waterbox.str

if [ $restraints = yes ]
then
sed -e "s/\$bb/$bb/g" -e "s/\$sc/$sc/g" -e "s/\$subs/$subs/g"  "${tooldir}/colvars.col" > ./colvars.col
fi

# ________ run the simulation ________
 
cat << EOF > ./npt.inp
source variables.str
source waterbox.str

structure    $psfin      
coordinates  $pdbin

set temp           $temp
if {$restart eq no} {
temperature        \$temp}

outputName         npt
if {$restart eq yes} {
binCoordinates     $coor 
binVelocities      $vel
extendedSystem     $xsc }
dcdfreq            $freq
dcdfile            $dcdout
restartfreq        500
dcdUnitCell        yes  
xstFreq            500 
outputEnergies     500     
outputTiming       500 

# Force-Field Parameters
paraTypeCharmm     on; 
parameters          $ffields/par_all36m_prot.prm
parameters          $ffields/par_all36_na.prm
parameters          $ffields/par_all36_carb.prm
parameters          $ffields/par_all36_lipid.prm
parameters          $ffields/par_all36_cgenff.prm
parameters          $ffields/toppar_water_ions.str
parameters          $ffields/toppar_dum_noble_gases.str
parameters          $ffields/toppar_all36_prot_d_aminoacids.str
parameters          $ffields/toppar_all36_prot_fluoro_alkanes.str
parameters          $ffields/toppar_all36_prot_heme.str
parameters          $ffields/toppar_all36_prot_na_combined.str
parameters          $ffields/toppar_all36_prot_retinol.str
parameters          $ffields/toppar_all36_na_nad_ppi.str
parameters          $ffields/toppar_all36_na_rna_modified.str
parameters          $ffields/toppar_all36_lipid_bacterial.str
parameters          $ffields/toppar_all36_lipid_cardiolipin.str
parameters          $ffields/toppar_all36_lipid_cholesterol.str
parameters          $ffields/toppar_all36_lipid_inositol.str
parameters          $ffields/toppar_all36_lipid_lps.str
parameters          $ffields/toppar_all36_lipid_miscellaneous.str
parameters          $ffields/toppar_all36_lipid_model.str
parameters          $ffields/toppar_all36_lipid_prot.str
parameters          $ffields/toppar_all36_lipid_pyrophosphate.str
parameters          $ffields/toppar_all36_lipid_sphingo.str
parameters          $ffields/toppar_all36_lipid_yeast.str
parameters          $ffields/toppar_all36_lipid_hmmm.str
parameters          $ffields/toppar_all36_lipid_detergent.str
parameters          $ffields/toppar_all36_carb_glycolipid.str
parameters          $ffields/toppar_all36_carb_glycopeptide.str
parameters          $ffields/toppar_all36_carb_imlab.str
parameters          $ffields/toppar_all36_label_spin.str
parameters          $ffields/toppar_all36_label_fluorophore.str

if {$extrain eq yes} {
parameters $par }

exclude             scaled1-4
1-4scaling          1.0
switching           on
vdwForceSwitching   yes
cutoff              12.0
switchdist          10.0
pairlistdist        16.0
stepspercycle       20
pairlistsPerCycle    2

# Integrator Parameters
timestep            1.0
rigidBonds          all
rigidTolerance      1.0E-10
nonbondedFreq       1
fullElectFrequency  1

# Periodic Boundary conditions. Need this only for start
if {$restart eq no}  {
cellBasisVector1     \$a   0.0   0.0;   # vector to the next image
cellBasisVector2    0.0    \$b   0.0;
cellBasisVector3    0.0   0.0    \$c;
cellOrigin          0.0   0.0 \$zcen;   # the *center* of the cell }

wrapWater           on;                # wrap water to central cell
wrapAll             on;                # wrap others
wrapNearest        off;                # use for non-rectangular cells (wrap to the nearest image)

# PME (for full-system periodic electrostatics)
source $pmeshspec

PME                yes;
PMEInterpOrder       6;                # interpolation order (spline order 6 in charmm)
PMEGridSizeX     \$fftx;                # should be close to the cell size 
PMEGridSizeY     \$ffty;                # corresponds to the charmm input fftx/y/z
PMEGridSizeZ     \$fftz;


# Constant Temperature Control

langevin            on 
langevinDamping     1
langevinTemp        300
langevinHydrogen    no

# Constant Pressure Control (variable volume)
useGroupPressure       yes;            # use a hydrogen-group based pseudo-molecular viral to calcualte pressure and
                                       # has less fluctuation, is needed for rigid bonds (rigidBonds/SHAKE)
useFlexibleCell         no;            # yes for anisotropic system like membrane 
useConstantRatio        no;            # keeps the ratio of the unit cell in the x-y plane constant A=B

langevinPiston          on;            # Nose-Hoover Langevin piston pressure control
langevinPistonTarget  $pressure ;      # target pressure in bar 1atm = 1.01325bar 
langevinPistonPeriod  50.0;            # oscillation period in fs. correspond to pgamma T=50fs=0.05ps 
                                       # f=1/T=20.0(pgamma)
langevinPistonDecay   25.0;            # oscillation decay time. smaller value correspons to larger random
                                       # forces and increased coupling to the Langevin temp bath.
                                       # Equall or smaller than piston period
langevinPistonTemp     300;            # coupled to heat bath

# Harmonic Restraints
if {$restraints eq  yes} {
colvars on
colvarsConfig colvars.col }

# Run

if {$restart eq no} {
minimize    10000 }

run $steps

EOF

if [ $restraints = yes ]
then
cp $bbrmsd ./bbrmsd.pdb
cp $scrmsd ./scrmsd.pdb
cp $subsrmsd ./subsrmsd.pdb
fi

namd2 +p$nproc npt.inp > $output

cp  ./npt.coor $coorout
cp  ./npt.vel  $velout
cp  ./npt.xsc  $xscout

