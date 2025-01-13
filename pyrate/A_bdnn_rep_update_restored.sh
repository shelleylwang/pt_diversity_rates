#!/bin/bash
#SBATCH --job-name=A_bdnn_rep_update_restored         # Job name
#SBATCH --array=1-10                     # Array with 10 independent tasks
#SBATCH --mem-per-cpu=300MB                # Memory per CPU core (adjust if needed)
#SBATCH --cpus-per-task=2                 # Number of CPU cores per task
#SBATCH --time=6-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/A_bdnn_rep_update_restored_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/A_bdnn_rep_update_restored_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules 
module purge
module load anaconda3/2024.2

python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py \
-restore_mcmc ./reptilia/mcmc_no_predictors/A_bdnn_update/reptilia_pyrate_${SLURM_ARRAY_TASK_ID}_A_update_G_BDS_BDNN_4_2Tc_mcmc.log  \
-BDNNmodel 1 -qShift ./data/Time_bins_ByStages.txt -mG \
-translate -175.0 -n 100000000 -s 10000 -p 2000 -BDNNnodes 4 2 -BDNNupdate_f 0.3 -thread 2 0 \
-wd ./reptilia/mcmc_no_predictors/A_bdnn_update/A_bdnn_update_restored_logs/ -out _A_update_restored -j ${SLURM_ARRAY_TASK_ID}