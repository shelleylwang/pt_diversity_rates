#!/bin/bash
#SBATCH --job-name=A_rjmcmc_rep         # Job name
#SBATCH --array=1-10                     # Array with 10 independent tasks
#SBATCH --mem-per-cpu=1GB                # Memory per CPU core (adjust if needed)
#SBATCH --time=6-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/A_rjmcmc_rep_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/A_rjmcmc_rep_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules 
module purge
module load anaconda3/2024.2

# Define a list of commands with varying `-j` values
python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -A 4 \
-qShift ./data/Time_bins_ByStages.txt -mG -n 200000000 -s 10000 -p 2000 \
-wd ./reptilia/mcmc_no_predictors -out _A_rjmcmc -j ${SLURM_ARRAY_TASK_ID}

