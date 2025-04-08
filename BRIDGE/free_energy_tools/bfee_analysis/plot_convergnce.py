import argparse,sys,os
import matplotlib.pyplot as plt
from BFEE2.commonTools import ploter

def parse_command_line(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('--hist', help='hist.czar.pmf file', required=True)
    return parser.parse_args()

def plotConvergence(rmsdList, file_name):
    """plot the time evolution of PMF rmsd

    Args:
        rmsdList (list or 1D np.array, float): time evolution of RMSD with respect to zero array
    """    

    plt.plot(range(1, len(rmsdList) + 1), rmsdList)
    plt.xlabel('Frame')
    plt.ylabel('RMSD (Colvars Unit)')
    plt.savefig(file_name)

args = parse_command_line(sys.argv)
path=os.getcwd()
hist_file=args.hist

plotConvergence(ploter.parseHistFile(hist_file),"rmsd.png")

