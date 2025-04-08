import argparse,sys,os
from BFEE2.postTreatment import postTreatment

def parse_command_line(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('--temp', help='Temperature', required=True)
    parser.add_argument('--MDengine', help='MD engine used', required=True)
    return parser.parse_args()

args = parse_command_line(sys.argv)

path=os.getcwd()
temperature= int(args.temp)
engine=args.MDengine

sys=postTreatment(temperature,engine,"geometric") 
contributions=sys.geometricBindingFreeEnergy(["./pmf1","./pmf2","./pmf3","./pmf4","./pmf5","./pmf6","./pmf7","./pmf8"],(10,0.1,0.1,0.1,0.1,0.1,30,10))
print("ΔG(site,c)", "\t","\t", "=" ,"\t", contributions[0])
print("ΔG(site,eulerTheta)", "\t", "=" ,"\t", contributions[1])
print("ΔG(site,eulerPhi)", "\t", "=" , "\t",contributions[2])
print("ΔG(site,eulerPsi)", "\t", "=" , "\t",contributions[3])
print("ΔG(site,polarTheta)", "\t", "=" ,"\t", contributions[4])
print("ΔG(site,polarPhi)", "\t", "=" ,"\t", contributions[5])
print("(1/beta)*ln(S*I*C0)", "\t", "=" ,"\t", contributions[6])
print("ΔG(bulk,c)", "\t","\t", "=" , "\t",contributions[7])
print("ΔG(bulk,o)", "\t","\t", "=" , "\t",contributions[8])
print("ΔG(total)", "\t","\t", "=" ,"\t", contributions[9])
