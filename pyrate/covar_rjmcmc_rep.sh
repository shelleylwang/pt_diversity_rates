#!/bin/bash
#SBATCH --job-name=covar_RJMCMC_rep          # Job name
#SBATCH --array=0-4                     # Array with 5 independent tasks
#SBATCH --cpus-per-task=4               # CPUs per task, enough for multithreading (-r 4)
#SBATCH --mem-per-cpu=16G                # Memory per CPU core (adjust if needed)
#SBATCH --time=5-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/covar_rjmcmc_rep_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/covar_rjmcmc_rep_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules
module purge
module load anaconda3/2024.2

# Define a list of commands with varying `-j` values
commands=(
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -mCov 5 -pC 0 -n 100000000 -s 10000 -p 1000 -A 4 -thread 2 0 -r 4 -j 6"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -mCov 5 -pC 0 -n 100000000 -s 10000 -p 1000 -A 4 -thread 2 0 -r 4 -j 7"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -mCov 5 -pC 0 -n 100000000 -s 10000 -p 1000 -A 4 -thread 2 0 -r 4 -j 8"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -mCov 5 -pC 0 -n 100000000 -s 10000 -p 1000 -A 4 -thread 2 0 -r 4 -j 9"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -mCov 5 -pC 0 -n 100000000 -s 10000 -p 1000 -A 4 -thread 2 0 -r 4 -j 10"
)

# Run the command corresponding to the current array index
eval "${commands[$SLURM_ARRAY_TASK_ID]}"
