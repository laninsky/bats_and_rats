structure_into_bedassle <- function(working_dir,file_name,missing_data) {

library(stringr)

# Throwing out error messages if any of the inputs are missing from the command line
x <- 0
error_one <- 0
error_two <- 0
error_three <- 0

killswitch <- "no"

if(missing(working_dir)) {
x <- 1
error_one <- 1
killswitch <- "yes"
}

if(missing(file_name)) {
x <- 1
error_two <- 2
killswitch <- "yes"
}

if(missing(missing_data)) {
x <- 1
error_three <- 3
killswitch <- "yes"
}

if(x==1) {
cat("Call the R function by structure_into_bedassle(working_dir,file_name), where:\nworking_dir == pathway to the folder with your structure.str file e.g. \"C:/blahblahblah\" \nfile_name == the name of your structure.str file e.g. \"data.structure.str\"\n\nExample of input:\nstructure_into_bedassle(\"C:/Users/Folder/\",\"data.structure.str\",\"0\")\n\nSpecific errors/missing inputs:\n")
}
if(error_one==1) {
cat("Sorry, I am missing a working directory pathway\nworking_dir == pathway to the folder with your structure.str file e.g. \"C:/blahblahblah\" \n\n")
}
if(error_two==2) {
cat("Sorry, I am missing a filename for your structure.str file\nfile_name == the name of your structure.str file e.g. \"structure.str.txt\"\n\n")
}
if(error_three==3) {
cat("Sorry, I am missing the value that your missing data will take e.g. \"0\" or \"-9\"")
}

#Checking status of working directory
print(noquote("STEP ONE: Loading in all the variables"))
print(noquote(""))
print(noquote("An error message after this indicates your working directory is not valid"))
flush.console()
setwd(working_dir)
print(noquote("Not to worry, your working directory IS valid! I've successfully set the working directory"))
print(noquote(""))
flush.console()

#Checking status of structure file
print(noquote("An error message after this indicates your structure.str file is not located in the directory you listed"))
flush.console()
input <- as.matrix(read.table(file_name,sep=""))
print(noquote("Not to worry, your file IS located in the directory!"))
print(noquote(""))
flush.console()

rm(error_one)
rm(error_two)
rm(x)
rm(file_name)
rm(killswitch)
rm(working_dir)

inputtemp <- input[order(input[,2]),]
pop_names <- unique(inputtemp[,2])
no_of_loci <- dim(inputtemp)[2]
input <- inputtemp[,1:2]
snp.names <- NULL

#Making sure that all the loci included in the matrix are bi-allelic
for (i in 3:no_of_loci) {
if(sum((unique(inputtemp[,i])!=missing_data)==TRUE)==2) {
input <- cbind(input,inputtemp[,i])
snp.names <- cbind(snp.names,i-2)
}
}

no_of_loci <- dim(input)[2] -2
no_of_cols <- dim(input)[2]
no_of_pops <- length(pop_names)

allele.counts <- matrix(0,ncol=no_of_loci,nrow=no_of_pops)
sample.sizes <- matrix(0,ncol=no_of_loci,nrow=no_of_pops)

rm(no_of_loci)

for (i in 3:no_of_cols) {
snpcall <- unique(input[,i])
snp <- snpcall[snpcall != missing_data][[1]]

for (j in 1:no_of_pops) {
temp <- subset(input[,i],input[,2]==pop_names[j])
allele.counts[j,i-2] <- sum(temp==snp)
sample.sizes[j,i-2] <- sum(temp!=missing_data)
}
}

colnames(allele.counts) <- snp.names
rownames(allele.counts) <- pop_names
colnames(sample.sizes) <- snp.names
rownames(sample.sizes) <- pop_names

write.table(pop_names,"pop_name_record.txt")
write.table(allele.counts, file="bedassle.allele.counts.txt", sep="\t", quote=FALSE, row.names=FALSE, col.names=FALSE)	
write.table(sample.sizes, file="bedassle.sample.sizes.txt", sep="\t", quote=FALSE, row.names=FALSE, col.names=FALSE)		

}
