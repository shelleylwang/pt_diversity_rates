#!/bin/bash
#SBATCH --job-name=B_bdnn_lats_only_tem         # Job name
#SBATCH --array=1-10                     # Array with 10 independent tasks
#SBATCH --mem-per-cpu=300MB                # Memory per CPU core (adjust if needed)
#SBATCH --cpus-per-task=2                # Number of CPU cores
#SBATCH --time=6-00:00:00               # Time limit, e.g., 1 day and 1 hour
#SBATCH --mail-type=begin               # Send email when job begins
#SBATCH --mail-type=end                 # Send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/B_bdnn_lats_only_tem_%j_%A_%a.out
#SBATCH --error=/scratch/gpfs/sw8569/B_bdnn_lats_only_tem_%j_%A_%a.err
#SBATCH --no-requeue                    # Disable requeue

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load necessary modules 
module purge
module load anaconda3/2024.2

python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 \
-qShift ./data/Time_bins_ByStages.txt -mG -translate -175.0 \
-trait_file ./data/temnospondyli_processed_data/temnospondyli_bdnn_trait_file.txt \
-n 100000000 -s 10000 -p 2000 -BDNNnodes 4 2 -seed 42 \
-wd ./temnospondyli/ -out _B_lats_only -j ${SLURM_ARRAY_TASK_ID}
