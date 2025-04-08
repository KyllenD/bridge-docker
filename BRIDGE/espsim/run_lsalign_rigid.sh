#!/bin/bash
/tool_deps/_conda/envs/__openbabel@2.4.1/bin/obabel -isdf query.sdf -omol2 -O query.mol2 -m 2>&1 &&
/tool_deps/_conda/envs/__openbabel@2.4.1/bin/obabel -isdf target.sdf -omol2 -O target.mol2 2>&1 &&
for j in query*.mol2; do python run_lsalign_rigid.py --target target.mol2 --query $j 2>&1; grep QUE output.txt > `head -n 2 $j | tail -n 1`; /tool_deps/_conda/envs/__openbabel@2.4.1/bin/obabel -ipdb `head -n 2 $j| tail -n 1` -O out.sdf 2>&1; cat out.sdf >> aligned.sdf; done
