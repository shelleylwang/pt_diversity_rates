#!/bin/bash
#SBATCH --job-name=model_8_rep_all_new_pyrate_inter         # Job name
#SBATCH --array=1-10                     # Array with 10 independent tasks
#SBATCH --mem-per-cpu=300MB                # Memory per CPU core (adjust if needed)
#SBATCH --time=14-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/workdir/pt_diversity_rates/err_out/model_8_rep_all_new_pyrate_inter_%j_%A_%a.out
#SBATCH --error=/workdir/pt_diversity_rates/err_out/model_8_rep_all_new_pyrate_inter_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /workdir/pt_diversity_rates

# Load necessary modules
module purge
module load python/3.12.7

# Activate virtual environment
source ~/pyrate_env/bin/activate

# Define command to run
python ../PyRate/PyRate.py updated_occurrence_analyses/data/Perm-Trias/pt_reptilia_all_pyrate_input_txt_PyRate.py  \
 -BDNNmodel 1 -fixShift updated_occurrence_analyses/data/Perm-Trias/Time_bins_1myr_and_stages.txt \
 -qShift updated_occurrence_analyses/data/Perm-Trias/Time_bins_ByStages.txt -mG \
 -trait_file updated_occurrence_analyses/data/Perm-Trias/bdnn_trait_files/pt_reptilia_all_lats_file_final.txt \
 -BDNNtimevar updated_occurrence_analyses/data/Perm-Trias/songEA_isotopic_data_pt_1myr/isotopic_1myr_binary_stages_timevar.txt \
 -BDNNtimetrait 0 -translate -175 -out _model_8_new_pyrate_inter -wd updated_occurrence_analyses/model_8/reptilia_all_new_pyrate_inter -n 200000000 -s 1000 -j ${SLURM_ARRAY_TASK_ID} 

