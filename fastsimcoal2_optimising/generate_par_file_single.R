# Loading libraries
library(tidyverse)

# Reading in likelihoods file to summarize min and max
likelihoods <- read_tsv("likelihoods.txt",col_names=FALSE)

# Reading in tpl file to replace paramaters with parameter estimates
tpl_file_name <- list.files(pattern=".tpl$")
temp_par <- readLines(tpl_file_name)

# Updating $NPOP1$
temp_par[4] <- as.numeric(likelihoods[1,9])

# Updating $NPOP2$
temp_par[5] <- as.numeric(likelihoods[1,10])

# Updating $MIG$
temp <- unlist(strsplit(temp_par[15]," "))
temp[2] <- as.numeric(likelihoods[1,7])
temp_par[15] <- paste(temp,collapse=" ")

temp <- unlist(strsplit(temp_par[16]," "))
temp[1] <- as.numeric(likelihoods[1,7])
temp_par[16] <- paste(temp,collapse=" ")

# Updating $MIG1$
temp <- unlist(strsplit(temp_par[18]," "))
temp[2] <- as.numeric(likelihoods[1,8])
temp_par[18] <- paste(temp,collapse=" ")

temp <- unlist(strsplit(temp_par[19]," "))
temp[1] <- as.numeric(likelihoods[1,8])
temp_par[19] <- paste(temp,collapse=" ")

# Updating $TMIG$ and $RESIZE2$
temp <- unlist(strsplit(temp_par[26]," "))
temp[1] <- as.numeric(likelihoods[1,6])
temp[5] <- as.numeric(likelihoods[1,11])
temp_par[26] <- paste(temp,collapse=" ")

# Updating $TDIV$ and $RESIZE3$
temp <- unlist(strsplit(temp_par[27]," "))
temp[1] <- as.numeric(likelihoods[1,5])
temp[5] <- as.numeric(likelihoods[1,12])
temp_par[27] <- paste(temp,collapse=" ")

# Writing out the temp_par file
write_lines(temp_par,gsub(".tpl",".par",tpl_file_name))
