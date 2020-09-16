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

# Duplicating this
invariant_row[10:length(invariant_row)] <- entry_to_duplicate

# Creating the output
output <- matrix(invariant_row,nrow=as.numeric(fastsimcoal_inputs[3,1]),ncol=length(invariant_row))
