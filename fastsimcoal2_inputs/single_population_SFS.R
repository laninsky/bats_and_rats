# Loading necessary libraries
library(tidyverse)

# Reading in the joint SFS
joint_SFS_file <- list.files(pattern="jointMAFpop1_0.obs")
joint_SFS <- readLines(joint_SFS_file)

# Getting rid of title rows
joint_SFS <- joint_SFS[-2]

# Getting rid of row titles
joint_SFS <- gsub(
