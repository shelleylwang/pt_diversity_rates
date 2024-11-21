#!/bin/bash
#SBATCH --job-name=bdmcmc_syn          # Job name
#SBATCH --array=0-9                     # Array with 5 independent tasks
#SBATCH --cpus-per-task=2               # CPUs per task, enough for multithreading (-r 4)
#SBATCH --mem-per-cpu=16G                # Memory per CPU core (adjust if needed)
#SBATCH --time=4-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/bdmcmc_syn_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/bdmcmc_syn_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules
module purge
module load anaconda3/2024.2

# Define a list of commands with varying `-j` values
commands=(
    "python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 -qShift ./data/Time_bins_ByStages.txt -mG -n 100000000 -s 10000 -p 2000 -wd ./synapsida/ -thread 2 0 -r 4 -j 1 -out '_bdmcmc'"
    "python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 -qShift ./data/Time_bins_ByStages.txt -mG -n 100000000 -s 10000 -p 2000 -wd ./synapsida/ -thread 2 0 -r 4 -j 2 -out '_bdmcmc'"
    "python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 -qShift ./data/Time_bins_ByStages.txt -mG -n 100000000 -s 10000 -p 2000 -wd ./synapsida/ -thread 2 0 -r 4 -j 3 -out '_bdmcmc'"
    "python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 -qShift ./data/Time_bins_ByStages.txt -mG -n 100000000 -s 10000 -p 2000 -wd ./synapsida/ -thread 2 0 -r 4 -j 4 -out '_bdmcmc'"
    "python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 -qShift ./data/Time_bins_ByStages.txt -mG -n 100000000 -s 10000 -p 2000 -wd ./synapsida/ -thread 2 0 -r 4 -j 5 -out '_bdmcmc'"
    "python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 -qShift ./data/Time_bins_ByStages.txt -mG -n 100000000 -s 10000 -p 2000 -wd ./synapsida/ -thread 2 0 -r 4 -j 6 -out '_bdmcmc'"
    "python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 -qShift ./data/Time_bins_ByStages.txt -mG -n 100000000 -s 10000 -p 2000 -wd ./synapsida/ -thread 2 0 -r 4 -j 7 -out '_bdmcmc'"
    "python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 -qShift ./data/Time_bins_ByStages.txt -mG -n 100000000 -s 10000 -p 2000 -wd ./synapsida/ -thread 2 0 -r 4 -j 8 -out '_bdmcmc'"
    "python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 -qShift ./data/Time_bins_ByStages.txt -mG -n 100000000 -s 10000 -p 2000 -wd ./synapsida/ -thread 2 0 -r 4 -j 9 -out '_bdmcmc'"
    "python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 -qShift ./data/Time_bins_ByStages.txt -mG -n 100000000 -s 10000 -p 2000 -wd ./synapsida/ -thread 2 0 -r 4 -j 10 -out '_bdmcmc'"
)

# Run the command corresponding to the current array index
eval "${commands[$SLURM_ARRAY_TASK_ID]}"
