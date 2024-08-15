source("../pyrate_utilities.r")
extract.ages.pbdb(file="/Users/shelleywang/Documents/PU RSII/BDNN_Arielli/data/Reptilia_cleaned_pyrate_input.csv", replicates=2)

# Created /Users/shelleywang/Documents/PU RSII/BDNN_Arielli/data/Reptilia_cleaned_pyrate_input_PyRate.py

# MCMC PyRate run (not BDNN): python PyRate.py reptilia/Reptilia_cleaned_pyrate_input_PyRate.py -qShift 
# data/Time_bins_ByStages.txt -mG -fixShift data/Time_bins_CrossStage.txt 

# BDNN run: python PyRate.py reptilia/Reptilia_cleaned_pyrate_input_PyRate.py -j 1 -fixShift data/Time_bins_CrossStage.txt 
# -BDNNmodel 1 -trait_file data/Reptilia_ohe_per_species.txt -qShift data/Time_bins_ByStages.txt -mG -A 0 -n 20000000 -s 2000
# Traits file needed to be: normalized continuous variables, no nulls, consistent data types, tab separated .txt