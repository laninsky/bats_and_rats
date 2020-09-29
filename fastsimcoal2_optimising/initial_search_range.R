# Modify following paths
original_search_range_folder <- "1"
folder_with_most_likely_replicate <- "1"

# Loading libraries
library(tidyverse)

# Reading in likelihoods file to summarize min and max
likelihoods <- read_tsv(paste(folder_with_most_likely_replicate,"/likelihoods.txt",sep=""),col_names=FALSE)

# Reading in est file to modify
est_file_name <- list.files(path=original_search_range_folder,pattern=".est$")
temp_est <- readLines(paste(original_search_range_folder,"/",est_file_name,sep=""))

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

if (create_new_est_file) {
  cat("Some parameter estimates are greater than the upper bound of the initial search range\nor within two orders of magnitude of the lower bound of the initial search range.\nA new est file has been written out to start again\n")
  # Updating $NPOP1$
  temp <- unlist(strsplit(temp_est[7]," "))
  temp[4] <- round(min(likelihoods[,2])/100)
  temp[5] <- max(likelihoods[,2])
  temp_est[7] <- paste(temp,collapse=" ")

  # Updating $NPOP2$
  temp <- unlist(strsplit(temp_est[8]," "))
  temp[4] <- round(min(likelihoods[,3])/100)
  temp[5] <- max(likelihoods[,3])
  temp_est[8] <- paste(temp,collapse=" ")

  # Updating $ANCNPOP1$
  temp <- unlist(strsplit(temp_est[9]," "))
  temp[4] <- round(min(likelihoods[,4])/100)
  temp[5] <- max(likelihoods[,4])
  temp_est[9] <- paste(temp,collapse=" ")

  # Updating $ANCNPOP2$
  temp <- unlist(strsplit(temp_est[10]," "))
  temp[4] <- round(min(likelihoods[,5])/100)
  temp[5] <- max(likelihoods[,5])
  temp_est[10] <- paste(temp,collapse=" ")

  # Updating $ANCNPOPTOT$
  temp <- unlist(strsplit(temp_est[11]," "))
  temp[4] <- round(min(likelihoods[,6])/100)
  temp[5] <- max(likelihoods[,6])
  temp_est[11] <- paste(temp,collapse=" ")

  # Updating $TDIV1$
  temp <- unlist(strsplit(temp_est[12]," "))
  temp[4] <- round(min(likelihoods[,7])/100)
  temp[5] <- max(likelihoods[,7])
  temp_est[12] <- paste(temp,collapse=" ")

  # Updating $TMIG$
  temp <- unlist(strsplit(temp_est[13]," "))
  temp[4] <- round(min(likelihoods[,8])/100)
  temp[5] <- max(likelihoods[,8])
  temp_est[13] <- paste(temp,collapse=" ")

  # Updating $MIG$
  temp <- unlist(strsplit(temp_est[14]," "))
  if (!(temp[4]==0 & temp[5]==0)) {
    temp[4] <- min(likelihoods[,9])/100
    temp[5] <- max(likelihoods[,9])
    temp_est[14] <- paste(temp,collapse=" ")
  }

  # Updating $MIG1$
  temp <- unlist(strsplit(temp_est[15]," "))
  if (!(temp[4]==0 & temp[5]==0)) {
    temp[4] <- min(likelihoods[,10])/100
    temp[5] <- max(likelihoods[,10])
    temp_est[15] <- paste(temp,collapse=" ")
  }
  write_lines(temp_est,paste(est_file_name,".new",sep=""))
} else {
  cat("No parameter estimate is greater than the upper bound of the initial search range\nor within two orders of magnitude of the lower bound of the initial search range. Good to go!\n")
}
