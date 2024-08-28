#!/bin/bash
#SBATCH --job-name=sam_my_job            # Set the job name
#SBATCH -o my_job_output_%j.txt      # Set the name of the job output file
#SBATCH --time=2:00:00               # Set the job time limit (2 hours here)
#SBATCH --mem=5G                     # Set the total job memory required (4 GB here)
#SBATCH --nodes=4                    # Set the number of nodes
#SBATCH --ntasks-per-node=6          # Set the number of tasks (cores) per node

module load Python/3.11.5-GCCcore-13.2.0

python --version

pip install --user virtualenv

virtualenv --system-site-packages ~/virtualenvs/test

source ~/virtualenvs/test/bin/activate

pip install --upgrade pip
# Store your GitHub token in a secure location and load it here
export GITHUB_TOKEN=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
# Clone the Python project repository securely
git clone -b main https://$GITHUB_TOKEN@github.com/Samatha1994/Stage1.git


cd Stage1
# Install required Python packages
pip install tensorflow Pillow Scipy pandas scikit-learn gdown
# Run the Python script
python main.py

cd ..
git clone -b main https://$GITHUB_TOKEN@github.com/Samatha1994/ecii.git

