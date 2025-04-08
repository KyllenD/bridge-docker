#!/bin/bash
sed -ne "/REMARK TITLE POSE $1 $2/,/END/p" all_poses.pdb >> Extracted.pdb
