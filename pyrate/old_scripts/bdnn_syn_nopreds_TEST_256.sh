#!/bin/bash
#SBATCH --job-name=BDNN_syn_nopreds_TEST_256    # Job name
#SBATCH --ntasks=1          # Each BDNN analysis runs as a single task
#SBATCH --mem-per-cpu=256G            # Memory per CPU core
#SBATCH --time=1-00:00:00       # days-hh:mm:ss
#SBATCH --mail-type=begin         # send email when job begins
#SBATCH --mail-type=end           # send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/bdnn_syn_nopreds_TEST_256_%j.out
#SBATCH --error=/scratch/gpfs/sw8569/bdnn_syn_nopreds_TEST_256_%j.err

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load any necessary modules (you may need to adjust this based on your cluster setup)
module purge
module load anaconda3/2024.2

# Run the analysis
srun python ../PyRate/PyRate.py \
    ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py \
    -BDNNmodel 1 \
    -qShift ./data/Time_bins_ByStages.txt \
    -mG \
    -translate 175.0 \
    -n 100000000 \
    -s 10000 \
    -p 2000 \
    -BDNNnodes 8 4 \
    -wd ./synapsida/ \
    -j 1 
