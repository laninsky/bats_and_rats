# Loading libraries
library(tidyverse)

# Reading in the vcf
temp <- read_tsv("temp",col_names=TRUE)

# Reading in fastsimcoal_inputs
fastsimcoal_inputs <- read_tsv("fastsimcoal_inputs",col_names=FALSE)
