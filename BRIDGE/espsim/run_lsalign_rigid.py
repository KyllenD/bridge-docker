#!/usr/bin/env python
import os,argparse,sys
def parse_command_line(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('--target', help='Database to search', required=True)
    parser.add_argument('--query', help='Names of molecules to extract', required=True)
    return parser.parse_args()
    
args = parse_command_line(sys.argv)
target = args.target
test_mol = args.query

os.system("./LSalign {0} {1} -rf 0 -H 1 -o output.txt".format(test_mol,target))
