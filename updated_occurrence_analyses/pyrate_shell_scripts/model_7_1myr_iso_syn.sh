#!/bin/bash
#SBATCH --job-name=model_7_1myr_iso_syn          # Job name
#SBATCH --array=1-10                     # Array with 10 independent tasks
#SBATCH --mem-per-cpu=200MB                # Memory per CPU core (adjust if needed)
#SBATCH --time=4-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/model_7_1myr_iso_syn_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/model_7_1myr_iso_syn_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules
module purge
module load anaconda3/2024.2

# Define command to run
python ../PyRate/PyRate.py updated_occurrence_analyses/data/Perm-Trias/pt_synapsida_pyrate_input_txt_PyRate.py \
 -BDNNmodel 1 -fixShift updated_occurrence_analyses/data/Perm-Trias/Time_bins_ByStages.txt \
 -qShift updated_occurrence_analyses/data/Perm-Trias/Time_bins_ByStages.txt -mG \
 -trait_file updated_occurrence_analyses/data/Perm-Trias/bdnn_trait_files/pt_synapsida_lats_file_final.txt \
 -BDNNtimevar updated_occurrence_analyses/data/Perm-Trias/songEA_isotopic_data_pt_1myr/isotopic_1myr_filtered_final.txt -translate -175 \
 -out _model_7_1myr_iso -wd updated_occurrence_analyses/model_7/isotopic_pt_1myr/synapsida -n 200000000 -s 10000 -j ${SLURM_ARRAY_TASK_ID} 



