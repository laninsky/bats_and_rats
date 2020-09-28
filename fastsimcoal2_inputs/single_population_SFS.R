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

# Adding first row to output
SFS_output[1,1:(d0_size+1)] <- unlist(strsplit(joint_SFS[1],split=" "))

# Adding remaining rows to output
for (i in 2:length(joint_SFS)) {
  SFS_output[1,i:(d0_size+i)] <- as.numeric(SFS_output[1,i:(d0_size+i)]) + as.numeric(unlist(strsplit(joint_SFS[i],split=" ")))
}

paste(paste("d0_",c(0:(SFS_size-1)),sep=""),collapse="\t")

# Writing out the single population SFS
output <- matrix(NA,ncol=1,nrow=3)
output[1,1] <- "1 observation"
output[2,1] <- paste(paste("d0_",c(0:(SFS_size-1)),sep=""),collapse="\t")
output[3,1] <- paste(SFS_output,collapse=" ")

write.table(output,"single_MAFpop0.obs",row.names=FALSE,col.names=FALSE,quote=FALSE)

