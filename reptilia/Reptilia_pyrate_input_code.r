source("../pyrate_utilities.r")
extract.ages.pbdb(file="/Users/shelleywang/Documents/PU RSII/BDNN_Arielli/data/Reptilia_cleaned_pyrate_input.csv", replicates=2)

# Created /Users/shelleywang/Documents/PU RSII/BDNN_Arielli/data/Reptilia_cleaned_pyrate_input_PyRate.py

# MCMC PyRate run (not BDNN): python PyRate.py reptilia/Reptilia_cleaned_pyrate_input_PyRate.py -qShift data/Time_bins_ByStages.txt -mG -fixShift data/Time_bins_CrossStage.txt 