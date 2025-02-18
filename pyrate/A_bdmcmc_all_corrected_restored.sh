#!/bin/bash
#SBATCH --job-name=A_bdmcmc_all_corrected_restored          # Job name
#SBATCH --mem-per-cpu=500MB                # Memory per CPU core (adjust if needed)
#SBATCH --ntasks=16                        # Number of tasks
#SBATCH --time=6-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/A_bdmcmc_all_corrected_restored_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/A_bdmcmc_all_corrected_restored_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules
module purge
module load anaconda3/2024.2

# Define reptilia commands

python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -A 2 \
-restore_mcmc ./reptilia/mcmc_no_predictors/A_bdmcmc/reptilia_pyrate_1_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 30000000 -s 20000 -p 2000 \
-wd ./reptilia/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 1 &
 
python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -A 2 \
-restore_mcmc ./reptilia/mcmc_no_predictors/A_bdmcmc/reptilia_pyrate_2_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 40000000 -s 20000 -p 2000 \
-wd ./reptilia/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 2 &

python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -A 2 \
-restore_mcmc ./reptilia/mcmc_no_predictors/A_bdmcmc/reptilia_pyrate_7_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 90000000 -s 20000 -p 2000 \
-wd ./reptilia/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 7 &

python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -A 2 \
-restore_mcmc ./reptilia/mcmc_no_predictors/A_bdmcmc/reptilia_pyrate_8_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 90000000 -s 20000 -p 2000 \
-wd ./reptilia/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 8 &

python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -A 2 \
-restore_mcmc ./reptilia/mcmc_no_predictors/A_bdmcmc/reptilia_pyrate_9_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 80000000 -s 20000 -p 2000 \
-wd ./reptilia/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 9 &

python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -A 2 \
-restore_mcmc ./reptilia/mcmc_no_predictors/A_bdmcmc/reptilia_pyrate_10_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 80000000 -s 20000 -p 2000 \
-wd ./reptilia/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 10 &

# Define synapsida commands

python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 \
-restore_mcmc ./synapsida/mcmc_no_predictors/A_bdmcmc/synapsida_pyrate_1_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 20000000 -s 20000 -p 2000 \
-wd ./synapsida/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 1 &

python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 \
-restore_mcmc ./synapsida/mcmc_no_predictors/A_bdmcmc/synapsida_pyrate_2_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 4000000 -s 20000 -p 2000 \
-wd ./synapsida/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 2 &

python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 \
-restore_mcmc ./synapsida/mcmc_no_predictors/A_bdmcmc/synapsida_pyrate_7_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 70000000 -s 20000 -p 2000 \
-wd ./synapsida/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 7 &

python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 \
-restore_mcmc ./synapsida/mcmc_no_predictors/A_bdmcmc/synapsida_pyrate_8_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 80000000 -s 20000 -p 2000 \
-wd ./synapsida/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 8 &

python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 \
-restore_mcmc ./synapsida/mcmc_no_predictors/A_bdmcmc/synapsida_pyrate_9_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 80000000 -s 20000 -p 2000 \
-wd ./synapsida/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 9 &

python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 2 \
-restore_mcmc ./synapsida/mcmc_no_predictors/A_bdmcmc/synapsida_pyrate_10_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 80000000 -s 20000 -p 2000 \
-wd ./synapsida/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 10 &


# Define temnospondyli commands

python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -A 2 \
-restore_mcmc ./temnospondyli/mcmc_no_predictors/A_bdmcmc/temnospondyli_pyrate_10_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 50000000 -s 20000 -p 2000 \
-wd ./temnospondyli/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 10 &

python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -A 2 \
-restore_mcmc ./temnospondyli/mcmc_no_predictors/A_bdmcmc/temnospondyli_pyrate_7_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 40000000 -s 20000 -p 2000 \
-wd ./temnospondyli/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 7 &

python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -A 2 \
-restore_mcmc ./temnospondyli/mcmc_no_predictors/A_bdmcmc/temnospondyli_pyrate_8_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 60000000 -s 20000 -p 2000 \
-wd ./temnospondyli/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 8 &

python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -A 2 \
-restore_mcmc ./temnospondyli/mcmc_no_predictors/A_bdmcmc/temnospondyli_pyrate_9_A_bdmcmc_corrected_G_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -n 50000000 -s 20000 -p 2000 \
-wd ./temnospondyli/mcmc_no_predictors/A_bdmcmc -out _A_bdmcmc_corrected_restored -j 9 &

# Wait for both background processes to complete
wait