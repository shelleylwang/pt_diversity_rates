#!/bin/bash
#SBATCH --job-name=bdnn_rep_fixshift_preds          # Job name
#SBATCH --array=0-8                     # Array with 5 independent tasks
#SBATCH --mem-per-cpu=4G                # Memory per CPU core (adjust if needed)
#SBATCH --time=6-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/bdnn_rep_fixshift_preds_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/bdnn_rep_fixshift_preds_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules 
module purge
module load anaconda3/2024.2

# Define a list of commands with varying `-j` values, starting from 2 because 1 was submitted in its own script (bdnn_rep_fixshift_preds_TEST) as a time test
commands=(
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -wd ./reptilia/ -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars.txt -thread 6 0 -j 2"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -wd ./reptilia/ -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars.txt -thread 6 0 -j 3"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -wd ./reptilia/ -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars.txt -thread 6 0 -j 4"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -wd ./reptilia/ -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars.txt -thread 6 0 -j 5"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -wd ./reptilia/ -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars.txt -thread 6 0 -j 6"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -wd ./reptilia/ -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars.txt -thread 6 0 -j 7"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -wd ./reptilia/ -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars.txt -thread 6 0 -j 8"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -wd ./reptilia/ -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars.txt -thread 6 0 -j 9"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -wd ./reptilia/ -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars.txt -thread 6 0 -j 10"
)

# Run the command corresponding to the current array index
eval "${commands[$SLURM_ARRAY_TASK_ID]}"
