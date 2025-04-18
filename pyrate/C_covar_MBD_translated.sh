#!/bin/bash
#SBATCH --job-name=C_covar_MBD_translated         # Job name
#SBATCH --array=1-10                     # Array with 10 independent tasks
#SBATCH --mem-per-cpu=400MB                # Memory per CPU core (adjust if needed)
#SBATCH --time=6-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/C_covar_MBD_translated_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/C_covar_MBD_translated_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules 
module purge
module load anaconda3/2024.2

# REPTILIA
# horseshoe env_vars
python ../PyRate/PyRateMBD.py -d ./reptilia/mcmc_fixshift_predictors/C_covar/reptilia_pyrate_${SLURM_ARRAY_TASK_ID}_G_COVhp_BDS_se_est.txt -var ./data/env_vars_data/MBD_translated/ -n 100000000 -s 10000 -p 2000 -b 1000 -out env_vars_horseshoe &
# horseshoe 1myr_temp
python ../PyRate/PyRateMBD.py -d ./reptilia/mcmc_fixshift_predictors/C_covar/reptilia_pyrate_${SLURM_ARRAY_TASK_ID}_G_COVhp_BDS_se_est.txt -var ./data/1myr_temp_data/MBD_translated/ -n 100000000 -s 10000 -p 2000 -b 1000 -out 1myr_temp_horseshoe & 

# SYNAPSIDA
# horseshoe env_vars
python ../PyRate/PyRateMBD.py -d ./synapsida/mcmc_fixshift_predictors/C_covar/synapsida_pyrate_${SLURM_ARRAY_TASK_ID}_C_G_COVhp_BDS_se_est.txt -var ./data/env_vars_data/MBD_translated/ -n 100000000 -s 10000 -p 2000 -b 1000 -out env_vars_horseshoe &
# horseshoe 1myr_temp
python ../PyRate/PyRateMBD.py -d ./synapsida/mcmc_fixshift_predictors/C_covar/synapsida_pyrate_${SLURM_ARRAY_TASK_ID}_C_G_COVhp_BDS_se_est.txt -var ./data/1myr_temp_data/MBD_translated/ -n 100000000 -s 10000 -p 2000 -b 1000 -out 1myr_temp_horseshoe &

# # TEMNOSPONDYLI
# horseshoe env_vars
python ../PyRate/PyRateMBD.py -d ./temnospondyli/mcmc_fixshift_predictors/C_covar/temnospondyli_pyrate_${SLURM_ARRAY_TASK_ID}_C_G_COVhp_BDS_se_est.txt  -var ./data/env_vars_data/MBD_translated/ -n 100000000 -s 10000 -p 2000 -b 1000 -out env_vars_horseshoe &
# horseshoe 1myr_temp
python ../PyRate/PyRateMBD.py -d ./temnospondyli/mcmc_fixshift_predictors/C_covar/temnospondyli_pyrate_${SLURM_ARRAY_TASK_ID}_C_G_COVhp_BDS_se_est.txt -var ./data/1myr_temp_data/MBD_translated/ -n 100000000 -s 10000 -p 2000 -b 1000 -out 1myr_temp_horseshoe

wait # Wait for all background jobs to finish before exiting the script

