#!/bin/bash
#SBATCH --job-name=BDNN_rep_nopreds_func_TEST       # create a short name for your job
#SBATCH --ntasks=1                # total number of tasks across all nodes
#SBATCH --mem-per-cpu=124G          # memory per cpu-core (4G is default)
#SBATCH --time=1-00:00:00       # days-hh:mm:ss
#SBATCH --mail-type=begin         # send email when job begins
#SBATCH --mail-type=end           # send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/bdnn_nopreds_func_TEST_%j.out
#SBATCH --error=/scratch/gpfs/sw8569/bdnn_nopreds_funct_TEST_%j.err

#SBATCH --no-requeue                     #What to do in case of failure

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load any necessary modules (you may need to adjust this based on your cluster setup)
module purge
module load anaconda3/2024.2

# Activate Python environment
# conda activate your_environment_name

# Define a function to run the BDNN command
run_bdnn() {
    local job_number=$1
    python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -qShift ./data/Time_bins_ByStages.txt -mG -translate 175.0 -n 100000000 -s 10000 -p 2000 -BDNNnodes 8 4 -wd ./reptilia/ -j "$job_number"
}

# Run the RJMCMC command using the function
run_bdnn 1