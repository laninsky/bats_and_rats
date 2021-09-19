Because ipyrad/stacks only output variable sites into the vcf file, we will need to modify the vcf to include monomorphic sites before generating the SFS, as these are important for timing of demographic events. In addition, we need the number of loci for the fastsimcoal2 analysis. Using the \*_stats.txt file from ipyrad (or the log files from stacks v2 if you are coming from there), we obtained the following numbers:  

Number of loci are the number of `retained_loci` that are also `total_filtered_loci`:  
`16,376 # Haplo`  
`13,533 # Bullimus`

Total number of monomorphic entries to add to vcf file is total `sequence matrix size` minus `snps matrix size` (if you are coming from a different pipeline: the total length of sequence minus the number of SNPs across that sequence):  
`1,493,950-33,969 = 1,459,981 bp # Haplo`  
`1,235,449-17,973 = 1,217,476 bp # Bullimus`

These numbers need to be placed in a file called fastsimcoal_inputs. First line is the number of loci, second line the number of monomorphic sites, and the final line, the name of the vcf file that will be added to e.g.
```
16376
1459981
HapFinal.vcf
```
```
13533
1217476
BullFinal.vcf
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
monomorphic_vcf.R duplicates the variable data in the vcf file up to the number of monomorphic sites needed to be added, and then changes the calls to invariant, in order to match the patterns of missingness found over the variable sites.  

Using this modified vcf file and the popfile (links below), we then use easySFS to generate the SFS. We run it twice, once profiling the vcf in order to assess the appropriate downprojection, and then generating the outfiles using the appropriate downprojection that maximizes the number of segregating sites.
```
module load Miniconda3/4.8.2

# commented lines only needed to be done once if code not run all in one go
# conda create -n easySFS
conda activate easySFS
# conda install -c bioconda dadi pandas
git clone https://github.com/isaacovercast/easySFS.git
cd easySFS
chmod 777 easySFS.py

# Note, the population order for easySFS is the order that populations are encountered
# in the popmap file. Make sure this is consistent between species to avoid getting
# things the wrong way around

# For Haplo
cd /scale_wlg_nobackup/filesets/nobackup/uoo03004/bats_rats/22Mar21/haplo/fastsimcoal2_inputs

easySFS/easySFS.py -i vcf_w_monomorphic.vcf -p Hap_Popfile.txt -a --preview
#Processing 2 populations - odict_keys(['N', 'S'])
#
#    Running preview mode. We will print out the results for # of segregating sites
#    for multiple values of projecting down for each population. The dadi
#    manual recommends maximizing the # of seg sites for projections, but also
#    a balance must be struck between # of seg sites and sample size.
#
#    For each population you should choose the value of the projection that looks
#    best and then rerun easySFS with the `--proj` flag.
#    
#N
#(2, 2211)	(3, 3287)	(4, 4286)	(5, 5208)	(6, 6114)	(7, 6819)	(8, 7643)	(9, 7953)	(10, 8681)	(11, 8550)	(12, 9181)	(13, 8512)	(14, 9035)	(15, 7122)	(16, 7498)	
#
#
#S
#(2, 1398)	(3, 2083)	(4, 2742)	(5, 3378)	(6, 4005)	(7, 4619)	(8, 5220)	(9, 5802)	(10, 6380)	(11, 6943)	(12, 7499)	(13, 8045)	(14, 8582)	(15, 9109)	(16, 9628)	(17, 10136)	(18, 10638)	(19, 11131)	(20, 11616)	(21, 12093)	(22, 12564)	(23, 13027)	(24, 13484)	(25, 13929)	(26, 14371)	(27, 14802)	(28, 15232)	(29, 15649)	(30, 16066)	(31, 16461)	(32, 16866)	(33, 17220)	(34, 17612)	(35, 17934)	(36, 18315)	(37, 18504)	(38, 18872)	(39, 18853)	(40, 19204)	(41, 19051)	(42, 19386)	(43, 19067)	(44, 19383)	(45, 18885)	(46, 19180)	(47, 18604)	(48, 18880)	(49, 18095)	(50, 18352)	(51, 17024)	(52, 17254)	(53, 15401)	(54, 15600)	(55, 12120)	(56, 12271)

# Selected values: N has the most segregating sites at 12, S has the most segregating sites at 42

easySFS/easySFS.py -i vcf_w_monomorphic.vcf -p Hap_Popfile.txt -a --proj=12,42

# For Bullimus
cd /scale_wlg_nobackup/filesets/nobackup/uoo03004/bats_rats/22Mar21/bullimus/fastsimcoal2_inputs

easySFS/easySFS.py -i vcf_w_monomorphic.vcf -p pop.txt -a --preview
#Processing 2 populations - odict_keys(['N', 'S'])
#
#    Running preview mode. We will print out the results for # of segregating sites
#    for multiple values of projecting down for each population. The dadi
#    manual recommends maximizing the # of seg sites for projections, but also
#    a balance must be struck between # of seg sites and sample size.
#
#    For each population you should choose the value of the projection that looks
#    best and then rerun easySFS with the `--proj` flag.
#    
#N
#(2, 1735)	(3, 2589)	(4, 3252)	(5, 3772)	(6, 4270)	(7, 4653)	(8, 5064)	(9, 5251)	(10, 5601)	(11, 5570)	(12, 5871)	(13, 5478)	(14, #5731)	(15, 4480)	(16, 4665)	
#
#
S
#(2, 1796)	(3, 2678)	(4, 3392)	(5, 4010)	(6, 4576)	(7, 5083)	(8, 5572)	(9, 5905)	(10, 6339)	(11, 6350)	(12, 6733)	(13, 6408)	(14, #6737)	(15, 6088)	(16, 6365)	(17, 5497)	(18, 5722)	(19, 4512)	(20, 4685)	(21, 3005)	(22, 3114)	
# Selected values: N has the most segregating sites at 12, S has the most segregating sites at 14

easySFS/easySFS.py -i vcf_w_monomorphic.vcf -p pop.txt -a --proj=12,14
```

[Hap_Popfile.txt](https://github.com/laninsky/bats_and_rats/blob/master/fastsimcoal2_inputs/Hap_Popfile.txt) and [pop.txt](https://github.com/laninsky/bats_and_rats/blob/master/fastsimcoal2_inputs/pop.txt) (Bullimus).  

Downprojection reduces the total number of sites in the output SFS, so to work out the average length of loci remaining (for modeling with fastsimcoal as data type "DNA"), we count the total length of the MSFS.obs downprojected SFS (the total number of sites in the SFS), and divide by the number of loci (top line of fastsimcoal_inputs). In this example, the SFS is called vcf_w_monomorphic_MSFS.obs:
```
head -n 3 vcf_w_monomorphic_MSFS.obs | tail -n 1 | sed 's/ /\+/g' | bc
```

The output for Haplo was `1271122`. When divided by the total number of loci in our dataset, `16376` (first line of fastsimcoal_inputs), this gives an average length of the DNA fragments for our fastsimcoal2 analysis of `77.62 bp` (we'll be rounding to `78`). We'll need this number when we eventually get to bootstrapping our most likely demographic scenario (https://github.com/laninsky/bats_and_rats/tree/master/fastsimcoal2_bootstrapping).

The output for Bullimus was `967993`. When divided by the total number of loci in our dataset, `13533` (first line of fastsimcoal_inputs), this gives an average length of the DNA fragments for our fastsimcoal2 analysis of `71.52 bp` (we'll be rounding to `72`). 

Based on these values, this is the tpl file generated for haplo:
https://github.com/laninsky/bats_and_rats/blob/master/fastsimcoal2_inputs/haplo.tpl

Based on these values, this is the tpl file generated for bullimus:
https://github.com/laninsky/bats_and_rats/blob/master/fastsimcoal2_inputs/bullimus.tpl

The initial est files were the same across both species.
Ongoing migration est file: https://github.com/laninsky/bats_and_rats/blob/master/fastsimcoal2_inputs/ongoing_migration.est  
Secondary contact est file: https://github.com/laninsky/bats_and_rats/blob/master/fastsimcoal2_inputs/secondary_contact.est
Ancestral migration est file: https://github.com/laninsky/bats_and_rats/blob/master/fastsimcoal2_inputs/ancestral_migration.est
Strict isolation est file: https://github.com/laninsky/bats_and_rats/tree/master/fastsimcoal2_inputs

The final scenario we want to model needs a different tpl and est file. This scenario is "single population" i.e. we are only modeling population size changes and considering N and S as panmictic.  
single population bullimus tpl file:  https://github.com/laninsky/bats_and_rats/blob/master/fastsimcoal2_inputs/bullimus_single.tpl

The est file is the same across species: https://github.com/laninsky/bats_and_rats/blob/master/fastsimcoal2_inputs/single.est

These files then will next be used to figure out the best likelihoods of our various scenarios (https://github.com/laninsky/bats_and_rats/tree/master/fastsimcoal2_optimising).
