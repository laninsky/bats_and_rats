Because ipyrad only outputs variable sites into the vcf file, we will need to modify the vcf to include monomorphic sites before generating the SFS, as these are important for timing of demographic events. In addition, we need the number of loci for the fastsimcoal2 analysis. Using the \*_stats.txt file, we obtained the following numbers:  

Number of loci are the number of `retained_loci` that are also `total_filtered_loci`:  
`16,376`

Total number of monomorphic entries to add to vcf file is total `sequence matrix size` minus `snps matrix size`:  
`1,493,950-33,969 = 1,459,981 bp`

These numbers need to be placed in a file called fastsimcoal_inputs. First line is the number of loci, second line the number of monomorphic sites, and the final line, the name of the vcf file that will be added to e.g.
```
16376
1459981
HapFinal.vcf
```

Then, make sure the monomorphic_vcf.R script is in the same directory as your vcf file and the fastsimcoal_inputs file before running the following:
```
filename=`cat fastsimcoal_inputs | head -n 3 | tail -n 1`
grep "##" $filename > header_row.txt
headerlineno=`wc -l header_row.txt | awk '{print $1}'`
headerlineno=$((headerlineno+1))
tail -n +$headerlineno $filename > temp
Rscript monomorphic_vcf.R
cat header_row.txt temp >> vcf_w_monomorphic.vcf
```
