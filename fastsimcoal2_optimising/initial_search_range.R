# Modify following paths
original_search_range_folder <- "1"
folder_with_most_likely_replicate <- "1"

# Loading libraries
library(tidyverse)

# Reading in likelihoods file to summarize min and max
likelihoods <- read_tsv(paste(original_search_range_folder,"/likelihoods.txt",sep=""),col_names=FALSE)

# Reading in est file to modify
est_file_name <- list.files(path=folder_with_most_likely_replicate,pattern=".est$")
temp_est <- readLines(paste(folder_with_most_likely_replicate,"/",est_file_name,sep=""))
