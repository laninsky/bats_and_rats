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

# Creating an object to record whether we need to recreate an est file or not
create_new_est_file <- FALSE

# Seeing whether $NPOP1$ is greater than the upper bound of the initial search range
# or within two orders of magnitude of the lower bound of the initial search range.
temp <- unlist(strsplit(temp_est[7]," "))
if (as.numeric(temp[5]) < as.numeric(likelihoods[1,2]) | as.numeric(likelihoods[1,2]) < as.numeric(temp[4])*100) {
  create_new_est_file <- TRUE
}

# Seeing whether $NPOP2$ is greater than the upper bound of the initial search range
# or within two orders of magnitude of the lower bound of the initial search range.
temp <- unlist(strsplit(temp_est[8]," "))
if (as.numeric(temp[5]) < as.numeric(likelihoods[1,3]) | as.numeric(likelihoods[1,3]) < as.numeric(temp[4])*100) {
  create_new_est_file <- TRUE
}

# Seeing whether $ANCNPOP1$ is greater than the upper bound of the initial search range
# or within two orders of magnitude of the lower bound of the initial search range.
temp <- unlist(strsplit(temp_est[9]," "))
if (as.numeric(temp[5]) < as.numeric(likelihoods[1,4]) | as.numeric(likelihoods[1,4]) < as.numeric(temp[4])*100) {
  create_new_est_file <- TRUE
}

# Seeing whether $ANCNPOP2$ is greater than the upper bound of the initial search range
# or within two orders of magnitude of the lower bound of the initial search range.
temp <- unlist(strsplit(temp_est[10]," "))
if (as.numeric(temp[5]) < as.numeric(likelihoods[1,5]) | as.numeric(likelihoods[1,5]) < as.numeric(temp[4])*100) {
  create_new_est_file <- TRUE
}

# Seeing whether $ANCNPOPTOT$ is greater than the upper bound of the initial search range
# or within two orders of magnitude of the lower bound of the initial search range.
temp <- unlist(strsplit(temp_est[11]," "))
if (as.numeric(temp[5]) < as.numeric(likelihoods[1,6]) | as.numeric(likelihoods[1,6]) < as.numeric(temp[4])*100) {
  create_new_est_file <- TRUE
}

# Seeing whether $TDIV1$ is greater than the upper bound of the initial search range
# or within two orders of magnitude of the lower bound of the initial search range.
temp <- unlist(strsplit(temp_est[12]," "))
if (as.numeric(temp[5]) < as.numeric(likelihoods[1,7]) | as.numeric(likelihoods[1,7]) < as.numeric(temp[4])*100) {
  create_new_est_file <- TRUE
}

# Seeing whether $TMIG$ is greater than the upper bound of the initial search range
# or within two orders of magnitude of the lower bound of the initial search range.
temp <- unlist(strsplit(temp_est[13]," "))
if (as.numeric(temp[5]) < as.numeric(likelihoods[1,8]) | as.numeric(likelihoods[1,8]) < as.numeric(temp[4])*100) {
  create_new_est_file <- TRUE
}

# Seeing whether $MIG$ is greater than the upper bound of the initial search range
# or within two orders of magnitude of the lower bound of the initial search range.
temp <- unlist(strsplit(temp_est[14]," "))
if (!(temp[4]==0 & temp[5]==0)) {
  if (as.numeric(temp[5]) < as.numeric(likelihoods[1,9]) | as.numeric(likelihoods[1,9]) < as.numeric(temp[4])*100) {
    create_new_est_file <- TRUE
  }
}

# Seeing whether $MIG1$ is greater than the upper bound of the initial search range
# or within two orders of magnitude of the lower bound of the initial search range.
temp <- unlist(strsplit(temp_est[15]," "))
if (!(temp[4]==0 & temp[5]==0)) {
  if (as.numeric(temp[5]) < as.numeric(likelihoods[1,10]) | as.numeric(likelihoods[1,10]) < as.numeric(temp[4])*100) {
    create_new_est_file <- TRUE
  }
}

write_lines(temp_est,paste(est_file_name,".new",sep=""))
