# Loading libraries
library(tidyverse)

# Reading in the vcf
temp <- read_tsv("temp",col_names=TRUE)

# Reading in fastsimcoal_inputs
fastsimcoal_inputs <- read_tsv("fastsimcoal_inputs",col_names=FALSE)

# Making an "invariant" row that will be duplicated for the total number of 
# invariant sites not recorded in the vcf.
invariant_row <- temp[1,]

# Grabbing the first ref/ref entry to duplicate
entry_to_duplicate <- as.character(invariant_row[grep("0/0",as.character(invariant_row))[1]])

# Duplicating this (assuming sample starts in 10th column)
invariant_row[10:length(invariant_row)] <- entry_to_duplicate

# Creating an output matrix with the invariant row duplicated for the total number of invariant sites
output <- matrix(invariant_row,nrow=as.numeric(fastsimcoal_inputs[3,1]),ncol=length(invariant_row),byrow=TRUE)

# Modifying some of the columns to give unique IDs, and to note the loci are monomorphic
output[,2] <- c(1:dim(output)[1])
output[,1] <- "Mono"
output[,3] <- paste(output[,1],output[,2],sep="_")

# Converting temp to matrix
temp <- as.matrix(temp)

# Binding the invariant rows to the rest of the vcf
temp <- rbind(temp,output)

# Write out the "new" vcf file
write.table(temp,"temp",col.names=TRUE,sep="\t",row.names=FALSE,quote=FALSE)
