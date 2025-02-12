#!/bin/bash
#SBATCH --job-name=B_bdnn_tem_stdscaled_log_cbrt_rerestorations        # Job name
#SBATCH --mem-per-cpu=300MB                # Memory per CPU core (adjust if needed)
#SBATCH --time=6-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/B_bdnn_tem_stdscaled_log_cbrt_rerestorations_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/B_bdnn_tem_stdscaled_log_cbrt_rerestorations_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules 
module purge
module load anaconda3/2024.2

# Commands to run

# Logs reps 4 and 8
python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 \
-restore_mcmc ./temnospondyli/mcmc_predictors/B_bdnn_stdscaled_log/temnospondyli_pyrate_4_B_stdscaled_log_G_BDS_BDNN_16_8TVc_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 \
-trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt -BDNNtimevar ./data/1myr_temp_data/1myr_temp_scaled_log.txt \
-n 20000000 -s 10000 -p 2000 -seed 42 \
-wd ./temnospondyli/mcmc_predictors/B_bdnn_stdscaled_log/ -out _B_stdscaled_log_rerestorations -j 4 &

python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 \
-restore_mcmc ./temnospondyli/mcmc_predictors/B_bdnn_stdscaled_log/temnospondyli_pyrate_8_B_stdscaled_log_G_BDS_BDNN_16_8TVc_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 \
-trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt -BDNNtimevar ./data/1myr_temp_data/1myr_temp_scaled_log.txt \
-n 10000000 -s 10000 -p 2000 -seed 42 \
-wd ./temnospondyli/mcmc_predictors/B_bdnn_stdscaled_log/ -out _B_stdscaled_log_rerestorations -j 8 &

# Cbrt reps 2, 3, 9
python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 \
-restore_mcmc ./temnospondyli/mcmc_predictors/B_bdnn_stdscaled_cbrt/temnospondyli_pyrate_2_B_stdscaled_cbrt_G_BDS_BDNN_16_8TVc_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 \
-trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt -BDNNtimevar ./data/1myr_temp_data/1myr_temp_scaled_cbrt.txt \
-n 20000000 -s 10000 -p 2000 -seed 42 \
-wd ./temnospondyli/mcmc_predictors/B_bdnn_stdscaled_cbrt/ -out _B_stdscaled_cbrt_rerestorations -j 2 &


python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 \
-restore_mcmc ./temnospondyli/mcmc_predictors/B_bdnn_stdscaled_cbrt/temnospondyli_pyrate_3_B_stdscaled_cbrt_G_BDS_BDNN_16_8TVc_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 \
-trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt -BDNNtimevar ./data/1myr_temp_data/1myr_temp_scaled_cbrt.txt \
-n 20000000 -s 10000 -p 2000 -seed 42 \
-wd ./temnospondyli/mcmc_predictors/B_bdnn_stdscaled_cbrt/ -out _B_stdscaled_cbrt_rerestorations -j 3 &


python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 \
-restore_mcmc ./temnospondyli/mcmc_predictors/B_bdnn_stdscaled_cbrt/temnospondyli_pyrate_9_B_stdscaled_cbrt_G_BDS_BDNN_16_8TVc_mcmc.log \
-qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 \
-trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt -BDNNtimevar ./data/1myr_temp_data/1myr_temp_scaled_cbrt.txt \
-n 10000000 -s 10000 -p 2000 -seed 42 \
-wd ./temnospondyli/mcmc_predictors/B_bdnn_stdscaled_cbrt/ -out _B_stdscaled_cbrt_rerestorations -j 9 &


# Wait for background processes to complete before exiting
wait
