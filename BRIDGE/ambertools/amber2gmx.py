import parmed as pmd
import sys,argparse

def parse_command_line(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('--coord', help='target molecule', required=True)
    parser.add_argument('--topol', help='query molecule', required=True)
    return parser.parse_args()

def merge_gromacs_topologies(top, output):
    with open(top, 'r') as f1:
        lines1 = f1.readlines()
    sections1 = parse_sections(lines1)
    merged_sections = merge_sections(sections1)
    with open(output, 'w') as f_out:
        f_out.write("\n")
        for section, content in merged_sections.items():
            if section in ["atomtypes","moleculetype","atoms","bonds","pairs","angles","dihedrals"]:
              f_out.write(f"[ {section} ]\n")
              f_out.writelines(content)
              f_out.write("\n")

def parse_sections(lines):
    sections = {}
    current_section = None
    for line in lines:
        if line.startswith("["):
            current_section = line.strip().strip("[]").strip()
            sections[current_section] = []
        elif current_section:
            sections[current_section].append(line)
    return sections

def merge_sections(sections1):
    merged = {}
    for section, content in sections1.items():
        merged[section] = content[:]
    return merged


args = parse_command_line(sys.argv)
amb_parm7=args.topol
amb_rst7=args.coord

amber = pmd.load_file(amb_parm7,amb_rst7) 
amber.save('output.top',format='gromacs') 
amber.save('output.gro') 
merge_gromacs_topologies('output.top', 'output.itp')
