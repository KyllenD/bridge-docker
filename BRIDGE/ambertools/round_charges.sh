#!/bin/bash

# Check if the input file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <input.mol2>"
  exit 1
fi

input_file="$1"
output_file="${input_file%.mol2}_rounded.mol2"

# Process the mol2 file
awk '
BEGIN {
  # Define the field separator
  FS=" "
}

{
  # If the line is in the ATOM section, round the charge to 3 decimal places
  if ($0 ~ /@<TRIPOS>ATOM/) {
    in_atom_section = 1
  } else if ($0 ~ /@<TRIPOS>BOND/) {
    in_atom_section = 0
  }

  if (in_atom_section) {
    # Round the charge (9th field) to 3 decimal places
    $9 = sprintf("%.3f", $9)
  }

  # Print the modified line
  print
}
' "$input_file" > "$output_file"

echo "Rounded charges saved to $output_file"
