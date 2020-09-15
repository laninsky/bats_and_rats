Because ipyrad only outputs variable sites into the vcf file, we will need to modify the vcf to include monomorphic sites before generating the SFS, as these are important for timing of demographic events. In addition, we need the number of loci and their average length for the fastsimcoal2 analysis. Using the \*_stats.txt file, we obtained the following numbers:  

Number of loci are the number of `retained_loci` that are also `total_filtered_loci`:  
`16,376`

Average length is total `sequence matrix size` divided by this number of loci:  
`1,493,950/16,376 = 91 bp`

Total number of monomorphic entries to add to vcf file is total `sequence matrix size` minus `snps matrix size`:  
`1,493,950-33,969 = 1,459,981 bp`

These numbers need to be placed in a file called fastsimcoal_inputs. First line is the number of loci, second line the average length in bp, third line the number of monomorphic sites, and final line, the name of the vcf file that will be added to.
