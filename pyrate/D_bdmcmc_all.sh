#!/bin/bash
#SBATCH --job-name=D_bdmcmc_all          # Job name
#SBATCH --array=1-10                     # Array with 10 independent tasks
#SBATCH --mem-per-cpu=600MB                # Memory per CPU core (adjust if needed)
#SBATCH --time=6-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/D_bdmcmc_all_%j_%D_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/D_bdmcmc_all_%j_%D_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules
module purge
module load anaconda3/2024.2

# Define command to run
python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -A 2 \
-fixShift ./data/Time_bins_ByStages.txt \
-qShift ./data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 \
-wd ./reptilia/mcmc_fixshift_no_predictors -out _D_bdmcmc_corrected -j ${SLURM_ARRAY_TASK_ID} &

python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 \
-fixShift ./data/Time_bins_ByStages.txt \
-qShift ./data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 \
-wd ./synapsida/mcmc_fixshift_no_predictors -out _D_bdmcmc_corrected -j ${SLURM_ARRAY_TASK_ID} &

python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -A 2 \
-fixShift ./data/Time_bins_ByStages.txt \
-qShift ./data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 \
-wd ./temnospondyli/mcmc_fixshift_no_predictors -out _D_bdmcmc_corrected -j ${SLURM_ARRAY_TASK_ID} &

# Wait for both background processes to complete
wait