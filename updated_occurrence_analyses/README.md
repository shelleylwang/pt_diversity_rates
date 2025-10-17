# Permian-Triassic/Guadalupian-Ladinian Diversity Rates Analyses

This project applies stochastic birth-death models and feed-forward Bayesian neural networks to the estimation of speciation and extinction rates of select taxa in deep time. 

Input data comes from multiple sources and includes both species-specific and time series data. Data specific to this project are: fossil occurrence datasets for terrestrial reptilia, all reptilia, and synapsida clades from both the PBDB and from field-work by Princeton Ph.D candidates. Predictors include oceanic data, paleolatitudes, localities, and various other climactic variables.

The PyRate program is developed by Torsten Hauffe and Daniele Silvestro [here](https://github.com/dsilvestro/PyRate/blob/master/pyrate_lib/bdnn_lib.py)


## Description of the data and file structure
The different data types included in this repository are listed below, along with brief descriptions for how to work with them.

### S1_Diversification analyses:
All outputs from MCMC analyses of speciation, extinction, and diversification rates
1.  Total number of folders: 34
2.  Total number of files: 228
3.  Missing data codes: None
4.  Main folders list and structure
    - 1_Syn_Rep(Terr)_MCMC_NoPred
        - reptilia_terr
        - synapsida
    - 2_Syn_Rep(Terr)_1Myr_RJMCMC_NoPred
        - reptilia_terr
        - synapsida
    - 3_Syn-Rep(Terr)_Stages_BDNN-MCMC_BRIDGE
        - reptilia_terr
            - PDPs_custom
            - predictor_importance
        - synapsida
            - PDPs_custom
            - predictor_importance
    - 5_Syn-Rep(All)_1Myr_RJMCMC_NoPred
        - reptilia_all
        - synapsida
    - 7_Syn-Rep(All)_Stages_BDNN-MCMC_Isot
        - reptilia_all
            - PDPs_custom
            - predictor_importance
        - synapsida
            - PDPs_custom
            - predictor_importance
    - 8_Syn-Rep(All)_1Myr_BDNN-MCMC_Isot_Stage
        - reptilia_all
        - synapsida
    - 9_Syn-Rep(Terr)_1Myr_BDNN-MCMC_BRIDGE_Stage
        - reptilia_terr
            - PDPs_custom
            - predictor_importance
        - synapsida
            - PDPs_custom
            - predictor_importance

    Subfolders: each first-order subfolder (those named after clades) will include some or all of the following classes of results files, depending on the model type:
    - Combined PyRate output from all replicates (mcmc.log, ex_rates.log, sp_rates.log, per_species_rates.log, marginal_rates.log, se_est.txt)
    - For BDNN models, the trained neural net saved as a pickle file (.pkl)
    - Markov chain diagnostic files (diagnostics_plots.pdf, ess.pdf)
    - Rates-through-time and diversity-through-time plots (DTT_RTT.pdf)
    - Second-order subfolders:
        - PDPs_custom: partial-dependence plots (.pdf)
        - predictor_importance: ranked incluence of predictors (.csv, .r, .pdf)
    - Birth-death model probabilities (mprob.png)

5.  Abbreviations used: 
    - Stages, Birth-Death model run with epoch-level bins
    - 1Myr, Birth-Death model run with 1myr bins (either default or default + epoch boundaries)
    - RJMCMC, Reversible-Jump MCMC algorithm
    - BDNN-MCMC, PyRate birth-death neural network MCMC algorithm
    - Rep, Reptilia
    - Syn, Synapsida
    - Terr, terrestrial
    - NoPred, no predictors
    - Pred, with predictors
    - BRIDGE, BRIDGE environmental predictors
    - Isot, isotopic environmental predictors from Song et.al
    - ess, Effective Sample Size
    - DTT, diversity-through-time
    - RTT, rates-through-time
    - mprob, model probability 


### S2_Datasets:
All model inputs, used to create the outputted files above
1.  Number of folders: 5
2.  Number of files: 14
3.  Missing data codes: None
4.  Main folders list and structure
    - Datasets
        - pyrate_input_files
        - time_bins
        - time_series_predictors
        - species_specific_predictors
        - predictor_backscale_txts

    Predictor values are z-transformed and their original means and standard deviations are saved in predictor_backscale_txts

    All preservation models were run with epoch-level time bins, or "Time_bins_ByStages.txt". Birth-death models received epoch-level time bins or 1Myr bins + epoch boundaries, or 1Myr bins depending on the analysis type. 

5.  Abbreviations used: 
    - pt, Permian-Triassic
    - lats, paleolatitude
    - timevar, time-variable


