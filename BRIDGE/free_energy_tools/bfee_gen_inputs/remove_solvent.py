def remove_solvent_from_topology(input_top, output_top):
    # Define solvent-related parameters
    solvent_includes = {"tip3p.itp", "tip4p.itp", "spc.itp", "tip5p.itp"}
    solvent_residues = {"SOL", "HOH", "WAT", "NA" , "CL"}  # Add more if needed (e.g., "NA", "CL")

    # State tracking variables
    in_moleculetype = False
    skip_current_molecule = False
    in_molecules_section = False

    with open(input_top, "r") as f_in, open(output_top, "w") as f_out:
        for line in f_in:
            stripped = line.strip()

            # Handle comments and empty lines
            if stripped.startswith(";") or stripped == "":
                if not skip_current_molecule:
                    f_out.write(line)
                continue

            # Check for new sections
            if stripped.startswith("["):
                # Exit skipped moleculetype sections
                if skip_current_molecule:
                    # Detect top-level sections to stop skipping
                    section = stripped.lower()
                    if any(s in section for s in ["moleculetype", "system", "molecules"]):
                        skip_current_molecule = False
                        f_out.write(line)
                    continue

                # Process new section
                if "moleculetype" in stripped.lower():
                    in_moleculetype = True
                else:
                    in_moleculetype = False
                    in_molecules_section = "molecules" in stripped.lower()

                f_out.write(line)
                continue

            # Process moleculetype definitions
            if in_moleculetype:
                # Extract molecule name
                parts = stripped.split(';')[0].split()
                if len(parts) >= 1:
                    current_molecule = parts[0]
                    if current_molecule in solvent_residues:
                        skip_current_molecule = True
                    else:
                        skip_current_molecule = False
                        f_out.write(line)
                continue

            # Skip lines if current molecule is solvent
            if skip_current_molecule:
                continue

            # Process [ molecules ] section
            if in_molecules_section:
                parts = stripped.split()
                if len(parts) >= 2 and parts[0] in solvent_residues:
                    continue  # Skip solvent entries
                f_out.write(line)
                continue

            # Process #include directives
            if stripped.startswith("#include"):
                include_file = stripped.split()[-1].strip('"\'')
                if include_file in solvent_includes:
                    continue  # Skip solvent includes
                f_out.write(line)
                continue

            # Write all other lines
            f_out.write(line)

if __name__ == "__main__":
    input_top = "topol.top"    # Replace with your input topology
    output_top = "topol_no_solvent.top"  # Output file name

    remove_solvent_from_topology(input_top, output_top)
    print(f"Solvent entries removed. Output saved to: {output_top}")
