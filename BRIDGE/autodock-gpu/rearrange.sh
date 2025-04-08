#!/bin/bash

# Read the file line by line
while IFS= read -r line
do
    # Check if the line starts with 'DE'
    if [[ ! $line =~ \< ]]; then
        # Extract DE number
        de_number=$line
    elif [[ $line =~ \<run\ id= ]]; then
        # Extract run id
        run_id=$(echo $line | grep -oP '(?<=id=")[0-9]+')
    elif [[ $line =~ \<free_NRG_binding ]]; then
        # Extract free energy binding
        free_NRG=$(echo $line | grep -oP '(?<=<free_NRG_binding>)[^<]+')
        # Print the desired format
        echo "$de_number, $run_id, $free_NRG"
    fi
done < "SUMMARY"

