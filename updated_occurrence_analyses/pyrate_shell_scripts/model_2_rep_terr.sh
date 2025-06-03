#!/bin/bash
#SBATCH --job-name=model_2_rep_terr          # Job name
#SBATCH --array=1-10                     # Array with 10 independent tasks
#SBATCH --mem-per-cpu=200MB                # Memory per CPU core (adjust if needed)
#SBATCH --time=2-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/model_2_rep_terr_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/model_2_rep_terr_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules
module purge
module load anaconda3/2024.2

# Define command to run
python ../PyRate/PyRate.py updated_occurrence_analyses/data/Perm-Trias/pt_reptilia_terr_pyrate_input_txt_PyRate.py \
 -A 4 -qShift updated_occurrence_analyses/data/Perm-Trias/Time_bins_ByStages.txt -mG \
 -n 100000000 -s 10000 -wd updated_occurrence_analyses/model_2_and_5/reptilia_terr -out _model_2 -j ${SLURM_ARRAY_TASK_ID} 