#!/bin/bash
#SBATCH --job-name=sam_my_job
#SBATCH -o my_job_output_%A_%a.txt
#SBATCH --time=2:00:00
#SBATCH --mem=38G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --array=0-63
#SBATCH --exclusive

# Store your GitHub token in a secure location and load it here
export GITHUB_TOKEN=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

# Clone into a unique directory based on SLURM_ARRAY_TASK_ID
git clone -b main https://$GITHUB_TOKEN@github.com/Samatha1994/ecii.git "ecii_${SLURM_ARRAY_TASK_ID}"
cd "ecii_${SLURM_ARRAY_TASK_ID}"

# Load necessary modules
module load Java/1.8.0_292
module load Maven/3.6.3

# Maven build
mvn clean install dependency:copy-dependencies
# Function to create symlinks, removing existing ones if necessary
create_symlink() {
    local target="$1"
    local link_name="$2"
    if [ -e "$link_name" ] || [ -L "$link_name" ]; then
        rm -rf "$link_name"
    fi
    ln -s "$target" "$link_name"
}

# Base directory for symlink targets
BASE_DIR="/homes/samatha94/ecii_${SLURM_ARRAY_TASK_ID}"
# Create symlinks for all required files
create_symlink "${BASE_DIR}/src/test/resources/expr_types/onto_combiner_test/onto_combiner_input2.owl" "/homes/samatha94/ecii/src/test/resources/expr_types/onto_combiner_test/onto_combiner_input2.owl"
create_symlink "${BASE_DIR}/src/test/resources/expr_types/onto_combiner_test/onto_combiner_input1.owl" "/homes/samatha94/ecii/src/test/resources/expr_types/onto_combiner_test/onto_combiner_input1.owl"
create_symlink "${BASE_DIR}/src/test/resources/expr_types/onto_combiner_test/onto_combiner_input3.owl" "/homes/samatha94/ecii/src/test/resources/expr_types/onto_combiner_test/onto_combiner_input3.owl"
create_symlink "${BASE_DIR}/src/test/resources/expr_types/induction_m_test/induction_test_2_null_error.config" "/homes/samatha94/ecii/src/test/resources/expr_types/induction_m_test/induction_test_2_null_error.config"
create_symlink "${BASE_DIR}/src/test/resources/expr_types/induction_m_test/induction_test.owl" "/homes/samatha94/ecii/src/test/resources/expr_types/induction_m_test/induction_test.owl"
echo "Listing symlinks to verify correct setup:"

ls -l /homes/samatha94/ecii/src/test/resources/expr_types/onto_combiner_test/onto_combiner_input2.owl
ls -l /homes/samatha94/ecii/src/test/resources/expr_types/onto_combiner_test/onto_combiner_input1.owl
ls -l /homes/samatha94/ecii/src/test/resources/expr_types/onto_combiner_test/onto_combiner_input3.owl
ls -l /homes/samatha94/ecii/src/test/resources/expr_types/induction_m_test/induction_test_2_null_error.config
ls -l /homes/samatha94/ecii/src/test/resources/expr_types/induction_m_test/induction_test.owl

# Verify and run the Java application

config_dir="/homes/samatha94/ExAI_inputs_and_outputs/Stage1_Results/config_files"

config_file="${config_dir}/neuron_${SLURM_ARRAY_TASK_ID}.config"

if [ -f "$config_file" ]; then
    echo "Running Java program for $config_file"
    java -ea -Xmx30000m -Xss128m -cp "target/classes:target/dependency/*" org.dase.ecii.Main -e "$config_file"
else
    echo "Configuration file $config_file does not exist. Exiting..."
fi

