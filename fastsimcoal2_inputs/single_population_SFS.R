# Loading necessary libraries
library(tidyverse)

# Reading in the joint SFS
joint_SFS_file <- list.files(pattern="jointMAFpop1_0.obs")
joint_SFS <- readLines(joint_SFS_file)

# Getting rid of title rows
joint_SFS <- joint_SFS[-c(1,2)]

# Getting rid of row titles
joint_SFS <- gsub(".*\t","",joint_SFS)

# Getting number of entries needed for output SFS
d0_size <- length(unlist(strsplit(joint_SFS[1],split=" ")))-1
d1_size <- length(joint_SFS)-1
SFS_size <- d0_size + d1_size + 1

# Creating output
SFS_output <- matrix(0,nrow=1,ncol=SFS_size)
