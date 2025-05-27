setwd("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli")
source("../PyRate/pyrate_utilities.r")

# Note that the input .txts need to have columns that are in the exact order specified by pyrate_utilities.r in order to work: "Species", "Status", "min_age", "max_age"
extract.ages(file="updated_occurrence_analyses/data/Perm-Trias/pt_reptilia_all_filtered_spellchecked_renamed.txt", replicates=10)
extract.ages(file="updated_occurrence_analyses/data/Perm-Trias/pt_reptilia_terr_filtered_spellchecked_renamed.txt", replicates=10)
extract.ages(file="updated_occurrence_analyses/data/Perm-Trias/pt_synapsida_filtered_spellchecked_renamed.txt", replicates=10)

