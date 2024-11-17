#!/bin/bash
#SBATCH --job-name=rep_covar_rjmcmc_FINAL          # Job name
#SBATCH --array=0-9                     # Array with 5 independent tasks
#SBATCH --mem-per-cpu=128G                # Memory per CPU core (adjust if needed)
#SBATCH --time=6-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/rep_covar_rjmcmc_FINAL_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/rep_covar_rjmcmc_FINAL_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules 
module purge
module load anaconda3/2024.2

# Define a list of commands with varying `-j` values
commands=(
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -qShift ./data/Time_bins_ByStages.txt -mG -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -mCov 5 -pC 0 -n 100000000 -s 10000 -p 1000 -A 4 -thread 2 0 -wd ./reptilia/ -j 1"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -qShift ./data/Time_bins_ByStages.txt -mG -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -mCov 5 -pC 0 -n 100000000 -s 10000 -p 1000 -A 4 -thread 2 0 -wd ./reptilia/ -j 2"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -qShift ./data/Time_bins_ByStages.txt -mG -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -mCov 5 -pC 0 -n 100000000 -s 10000 -p 1000 -A 4 -thread 2 0 -wd ./reptilia/ -j 3"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -qShift ./data/Time_bins_ByStages.txt -mG -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -mCov 5 -pC 0 -n 100000000 -s 10000 -p 1000 -A 4 -thread 2 0 -wd ./reptilia/ -j 4"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -qShift ./data/Time_bins_ByStages.txt -mG -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -mCov 5 -pC 0 -n 100000000 -s 10000 -p 1000 -A 4 -thread 2 0 -wd ./reptilia/ -j 5"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -qShift ./data/Time_bins_ByStages.txt -mG -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -mCov 5 -pC 0 -n 100000000 -s 10000 -p 1000 -A 4 -thread 2 0 -wd ./reptilia/ -j 6"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -qShift ./data/Time_bins_ByStages.txt -mG -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -mCov 5 -pC 0 -n 100000000 -s 10000 -p 1000 -A 4 -thread 2 0 -wd ./reptilia/ -j 7"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -qShift ./data/Time_bins_ByStages.txt -mG -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -mCov 5 -pC 0 -n 100000000 -s 10000 -p 1000 -A 4 -thread 2 0 -wd ./reptilia/ -j 8"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -qShift ./data/Time_bins_ByStages.txt -mG -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -mCov 5 -pC 0 -n 100000000 -s 10000 -p 1000 -A 4 -thread 2 0 -wd ./reptilia/ -j 9"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -qShift ./data/Time_bins_ByStages.txt -mG -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -mCov 5 -pC 0 -n 100000000 -s 10000 -p 1000 -A 4 -thread 2 0 -wd ./reptilia/ -j 10"
)

# Run the command corresponding to the current array index
eval "${commands[$SLURM_ARRAY_TASK_ID]}"
