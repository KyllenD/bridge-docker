#!/usr/bin/env python
import os,argparse,sys
def parse_command_line(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('--database', help='Database to search', required=True)
    return parser.parse_args()
    
args = parse_command_line(sys.argv)
database = args.database

f=open("list.txt","r")
test_mol = f.read().split()

for j in (test_mol):
	os.system("sed -ne '/{0}\\b/,/$$$$/\{/$$$$/!p;/$$$$/q\}' {1}".format(j,database))

