#!/bin/bash
#SBATCH --job-name=BDNN_reptilia    # Job name
#SBATCH --nodes=3                    # Request 3 nodes (1 per analysis)
#SBATCH --ntasks-per-node=1          # Each BDNN analysis runs as a single task
#SBATCH --cpus-per-task=1            # BDNN is sequential, so 1 CPU per task
#SBATCH --mem-per-cpu=16G            # Memory per CPU core
#SBATCH --time=5-01:00:00       # days-hh:mm:ss
#SBATCH --mail-type=begin         # send email when job begins
#SBATCH --mail-type=end           # send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/bdnn_rep_%j.out
#SBATCH --error=/scratch/gpfs/sw8569/bdnn_rep_%j.err

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load any necessary modules (you may need to adjust this based on your cluster setup)
module purge
module load anaconda3/2024.2

# Run the three analyses in parallel, one on each node
srun --exclusive -N1 -n1 python ../PyRate/PyRate.py \
    ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py \
    -BDNNmodel 1 \
    -qShift ./data/Time_bins_ByStages.txt \
    -mG \
    -translate 175.0 \
    -n 100000000 \
    -s 10000 \
    -p 2000 \
    -BDNNnodes 8 4 \
    -wd ./reptilia/ \
    -j 1 &

srun --exclusive -N1 -n1 python ../PyRate/PyRate.py \
    ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py \
    -BDNNmodel 1 \
    -qShift ./data/Time_bins_ByStages.txt \
    -mG \
    -translate 175.0 \
    -n 100000000 \
    -s 10000 \
    -p 2000 \
    -BDNNnodes 8 4 \
    -wd ./reptilia/ \
    -j 2 &

srun --exclusive -N1 -n1 python ../PyRate/PyRate.py \
    ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py \
    -BDNNmodel 1 \
    -qShift ./data/Time_bins_ByStages.txt \
    -mG \
    -translate 175.0 \
    -n 100000000 \
    -s 10000 \
    -p 2000 \
    -BDNNnodes 8 4 \
    -wd ./reptilia/ \
    -j 3 &

# Wait for all background jobs to complete
wait
```