#!/bin/bash
#SBATCH --job-name=C_bdnn_tem_scaled         # Job name
#SBATCH --array=0-9                     # Array with 10 independent tasks
#SBATCH --mem-per-cpu=4G                # Memory per CPU core (adjust if needed)
#SBATCH --time=6-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/C_bdnn_tem_scaled_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/C_bdnn_tem_scaled_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules 
module purge
module load anaconda3/2024.2

# Define a list of commands with varying `-j` values
commands=(
    "python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG  -n 100000000 -s 10000 -p 2000 -wd ./temnospondyli/ -trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars_scaled.txt -translate -175.0 -j 1 -out "_C_scaled""
    "python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG  -n 100000000 -s 10000 -p 2000 -wd ./temnospondyli/ -trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars_scaled.txt -translate -175.0 -j 2 -out "_C_scaled""
    "python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG  -n 100000000 -s 10000 -p 2000 -wd ./temnospondyli/ -trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars_scaled.txt -translate -175.0 -j 3 -out "_C_scaled""
    "python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG  -n 100000000 -s 10000 -p 2000 -wd ./temnospondyli/ -trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars_scaled.txt -translate -175.0 -j 4 -out "_C_scaled""
    "python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG  -n 100000000 -s 10000 -p 2000 -wd ./temnospondyli/ -trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars_scaled.txt -translate -175.0 -j 5 -out "_C_scaled""
    "python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG  -n 100000000 -s 10000 -p 2000 -wd ./temnospondyli/ -trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars_scaled.txt -translate -175.0 -j 6 -out "_C_scaled""
    "python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG  -n 100000000 -s 10000 -p 2000 -wd ./temnospondyli/ -trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars_scaled.txt -translate -175.0 -j 7 -out "_C_scaled""
    "python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG  -n 100000000 -s 10000 -p 2000 -wd ./temnospondyli/ -trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars_scaled.txt -translate -175.0 -j 8 -out "_C_scaled""
    "python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG  -n 100000000 -s 10000 -p 2000 -wd ./temnospondyli/ -trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars_scaled.txt -translate -175.0 -j 9 -out "_C_scaled""
    "python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG  -n 100000000 -s 10000 -p 2000 -wd ./temnospondyli/ -trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars_scaled.txt -translate -175.0 -j 10 -out "_C_scaled""
)

# Run the command corresponding to the current array index
eval "${commands[$SLURM_ARRAY_TASK_ID]}"
