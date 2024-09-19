source("../pyrate_utilities.r")
extract.ages.pbdb(file="/Users/shelleywang/Documents/PU RSII/BDNN_Arielli/data/Reptilia_cleaned_pyrate_input.csv", replicates=2)

# Created /Users/shelleywang/Documents/PU RSII/BDNN_Arielli/data/Reptilia_cleaned_pyrate_input_PyRate.py

# CoVar Model (not BDNN): python PyRate.py reptilia/Reptilia_cleaned_pyrate_input_PyRate.py -trait_file data/Reptilia_ohe_per_species.txt -mCov 5 -logT 1 -pC 0
# -fixShift data/Time_bins_CrossStage.txt -qShift data/Time_bins_ByStages.txt -mG -A 0 -n 20000000 -s 2000
# This is: a Covar BD model with fixed times of rate shifts, log transformed traits, TPP and Gamma preservation model, parameter estimation MCMC

# BDNN run: python PyRate.py reptilia/Reptilia_cleaned_pyrate_input_PyRate.py -j 1 -fixShift data/Time_bins_CrossStage.txt 
# -BDNNmodel 1 -trait_file data/Reptilia_ohe_per_species.txt -qShift data/Time_bins_ByStages.txt -mG -A 0 -n 20000000 -s 2000
# Traits file needed to be: normalized continuous variables, no nulls, consistent data types, tab separated .txt

# Predictor Importance: python PyRate.py -BDNN_pred_importance .\reptilia\pyrate_mcmc_logs\Reptilia_cleaned_pyrate_input_1_G_BDS_BDNN_16_8Tc_mcmc.log
# -BDNN_pred_importance_nperm 10 -b 2500000

# ^^ Continued in the reptiia_log.ipynb notebook