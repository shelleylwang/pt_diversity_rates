#!/bin/bash
#SBATCH --job-name=bdnn_rep_fixshift_preds_TEST          # Job name
#SBATCH --mem-per-cpu=2G                # Memory per CPU core (adjust if needed)
#SBATCH --time=6-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/bdnn_rep_fixshift_preds_TEST_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/bdnn_rep_fixshift_preds_TEST_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules 
module purge
module load anaconda3/2024.2

# Just first rep for time test
python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG -translate 175.0 -n 100000000 -s 10000 -p 2000 -wd ./reptilia/ -trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -BDNNtimevar ./data/env_vars.txt -thread 6 0 -j 1"
    