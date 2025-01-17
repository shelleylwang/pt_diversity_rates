#!/bin/bash
#SBATCH --job-name=C_bdnn_lats_only_rep # Job name
#SBATCH --array=1-10                     # Array with 10 independent tasks
#SBATCH --mem-per-cpu=200MB                # Memory per CPU core (adjust if needed)
#SBATCH --cpus-per-task=2        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --time=6-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/C_bdnn_lats_only_rep_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/C_bdnn_lats_only_rep_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules 
module purge
module load anaconda3/2024.2

python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 \
-fixShift ./data/Time_bins_ByStages.txt -qShift ./data/Time_bins_ByStages.txt -mG \
-trait_file ./data/reptilia_processed_data/reptilia_bdnn_trait_file.txt -BDNNnodes 4 2 \
-translate -175.0 -n 100000000 -s 10000 -p 2000 -wd ./reptilia/ -out _C_lats_only -j ${SLURM_ARRAY_TASK_ID}
