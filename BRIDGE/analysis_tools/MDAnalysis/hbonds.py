#!/usr/bin/env python

import sys, os
import argparse
import MDAnalysis
import MDAnalysis.analysis.hbonds
import pandas as pd
import csv

def parse_command_line(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('--idcd', help='input dcd')
    parser.add_argument('--ipdb', help='input pdb')
    parser.add_argument('--isegid1', help='segid 1')
    parser.add_argument('--isegid2', help='segid 2')
    parser.add_argument('--idistance', help='cutoff distance')
    parser.add_argument('--iangle', help='ctoff angle')
    parser.add_argument('--output', help='output')
    parser.add_argument('--ofreq_output', help='frequency output')
    parser.add_argument('--onumber_output', help='number of hbond output')
    parser.add_argument('--otime_output', help='time steps output')
    return parser.parse_args()

args = parse_command_line(sys.argv)

selection1 = "segid %s" % args.isegid1
selection2 = "segid %s" % args.isegid2
distance = float(args.idistance)
angle = float(args.iangle)

u = MDAnalysis.Universe(args.ipdb, args.idcd, topology_format="PDB", format="DCD")

h = MDAnalysis.analysis.hbonds.HydrogenBondAnalysis(u, selection1, selection2, distance = distance, angle = angle)
h.run()
h.generate_table()

df = pd.DataFrame.from_records(h.table)
df.to_csv(args.output, sep='\t')

t1 = list(h.count_by_type())
t2 = list(h.count_by_time())
t3 = list(h.timesteps_by_type())

with open(args.ofreq_output, 'w') as f:
    f.write("donor_index\tacceptor_index\tdonor_resname\tdonor_resid\tdonor_atom\thydrogen_atom\tacceptor_reansme\tacceptor_resid\tacceptor_atom\tfrequency\n")
    writer = csv.writer(f, delimiter='\t')
    writer.writerows(t1)


with open(args.onumber_output, 'w') as f1:
    f1.write("time_step\tno_of_h_bonds\n")
    writer = csv.writer(f1, delimiter='\t')
    writer.writerows(t2)

with open(args.otime_output, 'w') as f2:
    f2.write("donor_index\tacceptor_index\tdonor_resname\tdonor_resid\tdonor_atom\thydrogen_atom\tacceptor_reansme\tacceptor_resid\tacceptor_atom\ttime_step\n")
    writer = csv.writer(f2, delimiter='\t')
    writer.writerows(t3)

