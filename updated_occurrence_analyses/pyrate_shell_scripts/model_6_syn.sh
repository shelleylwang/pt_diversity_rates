#!/bin/bash
#SBATCH --job-name=model_6_syn          # Job name
#SBATCH --array=1-10                     # Array with 10 independent tasks
#SBATCH --mem-per-cpu=200MB                # Memory per CPU core (adjust if needed)
#SBATCH --time=4-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/model_6_syn_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/model_6_syn_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules
module purge
module load anaconda3/2024.2

# Define command to run
python ../PyRate/PyRate.py updated_occurrence_analyses/data/Guad-Ladin/gl_synapsida_epochs_filtered_PyRate.py \
 -BDNNmodel 1 -fixShift updated_occurrence_analyses/data/Guad-Ladin/Time_bins_ByStages.txt \
 -qShift updated_occurrence_analyses/data/Guad-Ladin/Time_bins_ByStages.txt -mG \
 -trait_file updated_occurrence_analyses/data/Guad-Ladin/bdnn_trait_files/gl_synapsida_lats_file_final.txt \
 -BDNNtimevar updated_occurrence_analyses/data/Guad-Ladin/songEA_isotopic_data/songEA_data_ordered_filtered.txt -translate -175 \
 -out _model_6 -wd updated_occurrence_analyses/model_6/synapsida -n 200000000 -s 10000 -j ${SLURM_ARRAY_TASK_ID} 



