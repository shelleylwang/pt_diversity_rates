#!/bin/bash
#SBATCH --job-name=BDNN_rep_nopreds    # Job name
#SBATCH --array=0-9                    # Array with 10 separate jobs
#SBATCH --mem-per-cpu=6G             # Memory per CPU core
#SBATCH --time=6-00:00:00              # days-hh:mm:ss
#SBATCH --mail-type=begin              # Send email when job begins
#SBATCH --mail-type=end                # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/bdnnrep_nopreds_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/bdnnrep_nopreds_%j_%A_%a.err

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules
module purge
module load anaconda3/2024.2

# Define the base command
commands=(
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -BDNNnodes 8 4 -wd ./reptilia/ -j 1"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -BDNNnodes 8 4 -wd ./reptilia/ -j 2"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -BDNNnodes 8 4 -wd ./reptilia/ -j 3"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -BDNNnodes 8 4 -wd ./reptilia/ -j 4"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -BDNNnodes 8 4 -wd ./reptilia/ -j 5"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -BDNNnodes 8 4 -wd ./reptilia/ -j 6"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -BDNNnodes 8 4 -wd ./reptilia/ -j 7"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -BDNNnodes 8 4 -wd ./reptilia/ -j 8"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -BDNNnodes 8 4 -wd ./reptilia/ -j 9"
    "python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 -n 100000000 -s 10000 -p 2000 -BDNNnodes 8 4 -wd ./reptilia/ -j 10"
)

# Run the command corresponding to the current array index
eval "${commands[$SLURM_ARRAY_TASK_ID]}"
