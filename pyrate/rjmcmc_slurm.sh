#!/bin/bash
#SBATCH --job-name=RJMCMC       # create a short name for your job
#SBATCH --nodes=1                 # node count
#SBATCH --ntasks=15                # total number of tasks across all nodes
#SBATCH --cpus-per-task=1         # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=4G          # memory per cpu-core (4G is default)
#SBATCH --time=1-01:00:00       # days-hh:mm:ss
#SBATCH --mail-type=begin         # send email when job begins
#SBATCH --mail-type=end           # send email when job ends
#SBATCH --mail-user=sw8569@princeton.edu
#SBATCH --output=/scratch/gpfs/sw8569/rjmcmc_%j.out
#SBATCH --error=/scratch/gpfs/sw8569/rjmcmc_%j.err

#SBATCH --no-requeue                     #What to do in case of failure

#SBATCH --ntasks-per-node=16                    #1 job per chain

# Change to the directory where the script should run
cd /scratch/gpfs/sw8569/BDNN_Arielli

# Load any necessary modules (you may need to adjust this based on your cluster setup)
module purge
module load anaconda3/2024.2

# Activate Python environment
# conda activate your_environment_name

# Run the RJMCMC command
python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -A 4 -qShift ./data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 -wd ./reptilia/ -j 6
python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -A 4 -qShift ./data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 -wd ./reptilia/ -j 7
python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -A 4 -qShift ./data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 -wd ./reptilia/ -j 8
python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -A 4 -qShift ./data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 -wd ./reptilia/ -j 9
python ../PyRate/PyRate.py ./data/reptilia_processed_data/reptilia_pyrate_PyRate.py -A 4 -qShift ./data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 -wd ./reptilia/ -j 10

python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 4 -qShift ./data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 -wd ./synapsida/ -j 6
python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 4 -qShift ./data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 -wd ./synapsida/ -j 7
python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 4 -qShift ./data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 -wd ./synapsida/ -j 8
python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 4 -qShift ./data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 -wd ./synapsida/ -j 9
python ../PyRate/PyRate.py ./data/synapsida_processed_data/synapsida_pyrate_PyRate.py -A 4 -qShift ./data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 -wd ./synapsida/ -j 10

python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -A 4 -qShift data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 -wd ./temnospondyli/  -j 6
python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -A 4 -qShift data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 -wd ./temnospondyli/  -j 7
python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -A 4 -qShift data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 -wd ./temnospondyli/  -j 8
python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -A 4 -qShift data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 -wd ./temnospondyli/  -j 9
python ../PyRate/PyRate.py ./data/temnospondyli_processed_data/temnospondyli_pyrate_PyRate.py -A 4 -qShift data/Time_bins_ByStages.txt -mG -n 200000000 -s 20000 -p 2000 -wd ./temnospondyli/  -j 10
