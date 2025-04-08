def split_pdbqt(input_file, pattern): 
    with open(input_file, 'r') as file: 
        lines = file.readlines() 
    part_num = 0 
    current_part = [] 
    for line in lines: 
        current_part.append(line) 
        if pattern in line.strip(): 
            # Save the current part to a file 
            with open(f"ligand_{part_num}.pdbqt", 'w') as part_file: 
                part_file.writelines(current_part) 
            part_num += 1 
            current_part = [] 
if __name__ == "__main__": 
    input_file = "ligand.pdbqt"  # Replace with your PDBQT file 
    pattern = "TORSDOF"  # Pattern at the end of each section 
    split_pdbqt(input_file, pattern) 
