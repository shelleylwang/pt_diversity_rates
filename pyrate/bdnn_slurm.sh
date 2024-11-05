#!/bin/bash
#SBATCH --job-name=BDNN_nopreds       # create a short name for your job
#SBATCH --nodes=1                 # node count
#SBATCH --ntasks=30                # total number of tasks across all nodes
#SBATCH --cpus-per-task=1         # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=4G          # memory per cpu-core (4G is default)
#SBATCH --time=1-01:00:00       # days-hh:mm:ss
#SBATCH --mail-type=begin         # send email when job begins
#SBATCH --mail-type=end           # send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/bdnn_nopreds_%j.out
#SBATCH --error=/scratch/gpfs/sw8569/bdnn_nopreds_%j.err

#SBATCH --no-requeue                     #What to do in case of failure

#SBATCH --ntasks-per-node=16                    #1 job per chain

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load any necessary modules (you may need to adjust this based on your cluster setup)
module purge
module load anaconda3/2024.2

# Activate Python environment
# conda activate your_environment_name

# Define a function to run the RJMCMC command
run_rjmcmc() {
    local job_number=$1
    python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -BDNNmodel 1 -qShift ./data/Time_bins_ByStages.txt -mG -translate 175.0 -n 200000000 -s 20000 -p 2000 -BDNNnodes 8 4 -wd /reptilia/ -j "$job_number"
    python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -BDNNmodel 1 -qShift ./data/Time_bins_ByStages.txt -mG -translate 175.0 -n 200000000 -s 20000 -p 2000 -BDNNnodes 8 4 -wd /synapsida/ -j "$job_number"
    python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -BDNNmodel 1 -qShift ./data/Time_bins_ByStages.txt -mG -translate 175.0 -n 200000000 -s 20000 -p 2000 -BDNNnodes 8 4 -wd /temnospondyli/ -j "$job_number"
}

# Run the RJMCMC command using the function
run_rjmcmc 1
run_rjmcmc 2
run_rjmcmc 3
run_rjmcmc 4
run_rjmcmc 5
run_rjmcmc 6
run_rjmcmc 7
run_rjmcmc 8
run_rjmcmc 9
run_rjmcmc 10