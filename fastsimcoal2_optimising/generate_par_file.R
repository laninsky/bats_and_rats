# Loading libraries
library(tidyverse)

# Reading in likelihoods file to summarize min and max
likelihoods <- read_tsv("likelihoods.txt",col_names=FALSE)

# Reading in tpl file to replace paramaters with parameter estimates
tpl_file_name <- list.files(pattern=".tpl$")
temp_par <- readLines(tpl_file_name)

# Updating $NPOP1$
temp_par[4] <- as.numeric(likelihoods[1,2])

# Updating $NPOP2$
temp_par[5] <- as.numeric(likelihoods[1,3])

# Updating $MIG$
temp <- unlist(strsplit(temp_par[15]," "))
temp[2] <- as.numeric(likelihoods[1,9])
temp_par[15] <- paste(temp,collapse=" ")

temp <- unlist(strsplit(temp_par[16]," "))
temp[1] <- as.numeric(likelihoods[1,9])
temp_par[16] <- paste(temp,collapse=" ")

# Updating $MIG1$
temp <- unlist(strsplit(temp_par[18]," "))
temp[2] <- as.numeric(likelihoods[1,10])
temp_par[18] <- paste(temp,collapse=" ")

temp <- unlist(strsplit(temp_par[19]," "))
temp[1] <- as.numeric(likelihoods[1,10])
temp_par[19] <- paste(temp,collapse=" ")

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

