import argparse,sys,os
from BFEE2.inputGenerator import inputGenerator 

def parse_command_line(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('--input_top', help='Input PSF/PARM', required=True)
    parser.add_argument('--input_coor', help='Input PDB/RST7', required=True)
    parser.add_argument('--temp', help='Temperature', required=True)
    parser.add_argument('--prot', help='MDTraj selection of the protein ', required=True)
    parser.add_argument('--lig', help='MDTraj selection of the ligand', required=True)
    return parser.parse_args()

args = parse_command_line(sys.argv)
forceFieldType='amber'
path=os.getcwd()
topFile = args.input_top
coorFile = args.input_coor
temperature= args.temp
selectionPro=args.prot
selectionLig=args.lig
forceFieldFiles=""

sys=inputGenerator() 
sys.generateNAMDGeometricFiles(path,topFile,coorFile,forceFieldType,forceFieldFiles,temperature,selectionPro,selectionLig,vmdPath='/cchem/galaxy/local_tools/VMD/bin/vmd',reflectionBoundary = False)

