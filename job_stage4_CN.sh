#!/bin/bash
#SBATCH --job-name=sam_my_job            # Set the job name
#SBATCH -o my_job_output_%j.txt      # Set the name of the job output file
#SBATCH --time=1:00:00               # Set the job time limit (1 hour here)
#SBATCH --mem=4G                     # Set the total job memory required (4 GB here)
#SBATCH --nodes=1                    # Set the number of nodes
#SBATCH --ntasks-per-node=1          # Set the number of tasks (cores) per node

module load Python/3.11.5-GCCcore-13.2.0
python –version
pip install --user virtualenv
virtualenv --system-site-packages ~/virtualenvs/test
source ~/virtualenvs/your_venv/bin/activate

# Store your GitHub token in a secure location and load it here
export GITHUB_TOKEN=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
# Clone the Python project repository securely
git clone -b main https://$GITHUB_TOKEN@github.com/Samatha1994/Stage4_CN.git

cd Stage4_CN

# Install required Python packages
pip install pandas openpyxl scipy

# Run the Python script
python main.py
cd ..

