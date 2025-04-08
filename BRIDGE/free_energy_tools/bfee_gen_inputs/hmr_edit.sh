for j in ./BFEE/00*/*.conf ; do sed -i '/margin/d' $j; sed -i "/temperature/a margin 4" $j;sed -i '/run/d' $j; sed -i '$arun 2500000' $j; sed -i '/timestep/d' $j; sed -i "/PMEGridSpacing/a timestep 4.0" $j; done

for j in ./BFEE/00*/colvars_1.in; do sed -i 's/colvarsTrajFrequency      5000/colvarsTrajFrequency      2500/' $j; sed -i 's/colvarsRestartFrequency   5000/colvarsRestartFrequency   2500/' $j; sed -i 's/historyfreq    50000/historyfreq    25000/' $j ; sed -i 's/FullSamples    10000/FullSamples    5000/' $j;done

sed -i 's/colvarsTrajFrequency      5000/colvarsTrajFrequency      2500/' ./BFEE/000_eq/colvars.in
sed -i 's/colvarsRestartFrequency   5000/colvarsRestartFrequency   2500/' ./BFEE/000_eq/colvars.in
sed -i 's/outputFreq 10000/outputFreq 5000/' ./BFEE/000_eq/colvars.in 

sed -i '/run/d' ./BFEE/008_RMSDUnbound/008.2_abf_1.conf; 
sed -i '$arun 500000' ./BFEE/008_RMSDUnbound/008.2_abf_1.conf
sed -i '/run/d' ./BFEE/007_r/007.2_abf_1.conf ;
sed -i '$arun 10000000' ./BFEE/007_r/007.2_abf_1.conf

 
