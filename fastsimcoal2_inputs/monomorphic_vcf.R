# 0.2: 17Aug21: added in print statements to track progress
# 0.1: 22Mar21: modified the monomorphic sites added from no missing data to patterns of missing data reflecting the variable sites
# 0.0: original code

# Loading libraries
library(tidyverse)
print("1/11 Loaded libraries")

# Reading in the vcf
temp <- read_tsv("temp",col_names=TRUE)
print("2/11 Read in vcf")

# Reading in fastsimcoal_inputs
fastsimcoal_inputs <- read_tsv("fastsimcoal_inputs",col_names=FALSE)
print("3/11 Read in fastsimcoal_inputs")

# Creating a temp_monomorphic dataframe consisting of just monomorphic data
gsub_function_01 <- function(x) (gsub("0/1:","0/0:",x))
gsub_function_10 <- function(x) (gsub("1/0:","0/0:",x))
gsub_function_11 <- function(x) (gsub("1/1:","0/0:",x))
print("4/11 Creating functions for simulating monomorphic data")  

temp_monomorphic <- temp %>% mutate_all(gsub_function_01)
temp_monomorphic <- temp_monomorphic %>% mutate_all(gsub_function_10)
temp_monomorphic <- temp_monomorphic %>% mutate_all(gsub_function_11)
print("5/11 Simulating monomorphic data")

# Figuring out the number of times this temp_monomorphic dataframe
# needs to be copied in order to have the number of required lines
number_of_reps_needed <- as.numeric(fastsimcoal_inputs[2,1])/dim(temp)[1]
full_reps <- floor(number_of_reps_needed)
rest_of_lines <- (number_of_reps_needed - floor(number_of_reps_needed))*dim(temp)[1]
print("6/11 Calculating how much monomorphic data needs to added to vcf")

output_full_reps <- temp_monomorphic[rep(1:dim(temp_monomorphic)[1],full_reps),]
output_rest_of_lines <- temp_monomorphic[1:rest_of_lines,]
output <- rbind(output_full_reps,output_rest_of_lines)
print("7/11 Adding monomorphic data")
  
# Modifying some of the columns to give unique IDs, and to note the loci are monomorphic
output[,2] <- c(1:dim(output)[1])
output[,1] <- "Mono"
output <- output %>% mutate(ID=paste("Mono_",.[[2]],sep=""))
print("8/11 Renaming monomorphic data loci")

# Converting temp to matrix
temp <- as.matrix(temp)
print("9/11 Converting to matrix")

# Binding the invariant rows to the rest of the vcf
temp <- rbind(temp,output)
print("10/11 Combining variable and monomorphic data")

# Write out the "new" vcf file
write.table(temp,"temp",col.names=TRUE,sep="\t",row.names=FALSE,quote=FALSE)
print("11/11 Writing out data")
