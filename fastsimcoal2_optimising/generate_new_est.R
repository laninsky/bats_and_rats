# Loading libraries
library(tidyverse)

# Reading in likelihoods file to summarize min and max
likelihoods <- read_tsv("likelihoods.txt",col_names=FALSE)

# Reading in est file to modify
est_file_name <- list.files(pattern=".est$")
temp_est <- readLines(est_file_name)

# Updating $NPOP1$
temp <- unlist(strsplit(temp_est[7]," "))
temp[4] <- min(likelihoods[,2])
temp[5] <- max(likelihoods[,2])
temp_est[7] <- paste(temp,collapse=" ")

# Updating $NPOP2$
temp <- unlist(strsplit(temp_est[8]," "))
temp[4] <- min(likelihoods[,3])
temp[5] <- max(likelihoods[,3])
temp_est[8] <- paste(temp,collapse=" ")

# Updating $ANCNPOP1$
temp <- unlist(strsplit(temp_est[9]," "))
temp[4] <- min(likelihoods[,4])
temp[5] <- max(likelihoods[,4])
temp_est[9] <- paste(temp,collapse=" ")

# Updating $ANCNPOP2$
temp <- unlist(strsplit(temp_est[10]," "))
temp[4] <- min(likelihoods[,5])
temp[5] <- max(likelihoods[,5])
temp_est[10] <- paste(temp,collapse=" ")

# Updating $ANCNPOPTOT$
temp <- unlist(strsplit(temp_est[11]," "))
temp[4] <- min(likelihoods[,6])
temp[5] <- max(likelihoods[,6])
temp_est[11] <- paste(temp,collapse=" ")

# Updating $TDIV1$
temp <- unlist(strsplit(temp_est[12]," "))
temp[4] <- min(likelihoods[,7])
temp[5] <- max(likelihoods[,7])
temp_est[12] <- paste(temp,collapse=" ")

# Updating $TMIG$
temp <- unlist(strsplit(temp_est[13]," "))
temp[4] <- min(likelihoods[,8])
temp[5] <- max(likelihoods[,8])
temp_est[13] <- paste(temp,collapse=" ")

# Updating $MIG$
temp <- unlist(strsplit(temp_est[14]," "))
if (!(temp[4]==0 & temp[5]==0)) {
  temp[4] <- min(likelihoods[,9])
  temp[5] <- max(likelihoods[,9])
  temp_est[14] <- paste(temp,collapse=" ")
}

# Updating $MIG1$
temp <- unlist(strsplit(temp_est[15]," "))
if (!(temp[4]==0 & temp[5]==0)) {
  temp[4] <- min(likelihoods[,10])
  temp[5] <- max(likelihoods[,10])
  temp_est[15] <- paste(temp,collapse=" ")
}

write_lines(temp_est,paste(est_file_name,".new",sep=""))
