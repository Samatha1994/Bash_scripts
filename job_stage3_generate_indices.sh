#!/bin/bash



# Directory where config files are located

config_dir="/homes/samatha94/ExAI_inputs_and_outputs/Stage1_Results/config_files"

indices_file="/homes/samatha94/ExAI_inputs_and_outputs/Stage3_Results/indices.txt"



# Find the first 5 .txt files, extract the indices, and save them to a file

find "${config_dir}" -maxdepth 1 -name 'neuron_*_results_ecii_V2.txt' | sort -V | head -n 64 | grep -oP '(?<=neuron_)\d+' > "${indices_file}"

