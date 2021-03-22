Because ipyrad/stacks only output variable sites into the vcf file, we will need to modify the vcf to include monomorphic sites before generating the SFS, as these are important for timing of demographic events. In addition, we need the number of loci for the fastsimcoal2 analysis. Using the \*_stats.txt file from ipyrad (or the log files from stacks v2 if you are coming from there), we obtained the following numbers:  

Number of loci are the number of `retained_loci` that are also `total_filtered_loci`:  
`16,376`

Total number of monomorphic entries to add to vcf file is total `sequence matrix size` minus `snps matrix size` (if you are coming from a different pipeline: the total length of sequence minus the number of SNPs across that sequence):  
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

Using this modified vcf file and the popfile (snippet below), we then use easySFS to generate the SFS. We run it twice, once profiling the vcf in order to assess the appropriate downprojection, and then generating the outfiles using the appropriate downprojection that maximizes the number of segregating sites.
```
#!/bin/bash -e
#SBATCH -A uoo03004
#SBATCH -J easySFS 
#SBATCH --time 12:00:00
#SBATCH -N 1
#SBATCH -c 1
#SBATCH -n 1
#SBATCH --mem=10GB
#SBATCH --chdir=/nesi/nobackup/uoo03004/bats_rats

module load Miniconda3/4.8.2

#conda create -n easySFS
source /nesi/nobackup/uoo00105/chickadees/bin/miniconda3/etc/profile.d/conda.sh 
conda activate easySFS
conda install -c bioconda dadi pandas
#git clone https://github.com/isaacovercast/easySFS.git
#cd easySFS
#chmod 777 easySFS.py

# This initial code suggested downprojecting to 42 for S, and 12 for N
# would maximize the number of segregating sites
# easySFS/easySFS.py -i vcf_w_monomorphic.vcf -p Hap_Popfile.txt -a --preview

easySFS/easySFS.py -i vcf_w_monomorphic.vcf -p Hap_Popfile.txt -a --proj=42,12
```
Hap_Popfile.txt snippet:
```
JAE1726 S
JAE1727 S
JAE1728 S
JAE1734 S
JAE1752 S
JAE1755 S
JAE1758 S
JAE1760 S
JAE1780 N
JAE1782 N
```
Downprojection reduces the total number of sites in the output SFS, so to work out the average length of loci remaining (for modeling with fastsimcoal as data type "DNA"), we count the total length of the MSFS.obs downprojected SFS (the total number of sites in the SFS), and divide by the number of loci (top line of fastsimcoal_inputs). In this example, the SFS is called vcf_w_monomorphic_MSFS.obs:
```
head -n 3 vcf_w_monomorphic_MSFS.obs | tail -n 1 | sed 's/ /\+/g' | bc
```
The output for this example was `1.46442e+06`. When divided by the total number of loci in our dataset, `16376` (first line of fastsimcoal_inputs), this gives an average length of the DNA fragments for our fastsimcoal2 analysis of `89.4 bp` (we'll be rounding to `89`). We'll need this number when we eventually get to bootstrapping our most likely demographic scenario (https://github.com/laninsky/bats_and_rats/tree/master/fastsimcoal2_bootstrapping).

Based on these values, this is the tpl file generated:
```
//Parameters for the coalescence simulation program : fastsimcoal.exe
2 samples to simulate :
//Population effective sizes (number of genes)
$NPOP1$
$NPOP2$
//Samples sizes and samples age
42
12
//Growth rates : negative growth implies population expansion
0
0
//Number of migration matrices : 0 implies no migration between demes
3
//Migration matrix 0
0 $MIG$
$MIG$ 0
//Migration matrix 1
0 $MIG1$
$MIG1$ 0
//Migration matrix 2
0 0
0 0
//historical event: time, source, sink, migrants, new deme size, growth rate, migr mat index
3 historical event
$TMIG$ 0 0 1 $RESIZE1$ 0 1
$TMIG$ 1 1 1 $RESIZE2$ 0 1
$TDIV1$ 0 1 1 $RESIZE3$ 0 2
//Number of independent loci [chromosome]
1
//Per chromosome: Number of contiguous linkage Block: a block is a set of contiguous loci
1
//per Block:data type, number of loci, per gen recomb and mut rates
FREQ 1 0 1.18E-08
```
Ongoing migration initial est file:
```
// Priors and rules file
// *********************

[PARAMETERS]
//#isInt? #name #dist.#min #max
//all Ns are in number of haploid individuals
1 $NPOP1$ unif 0 1E9 output
1 $NPOP2$ unif 0 1E9 output
1 $ANCNPOP1$ unif 0 1E9 output
1 $ANCNPOP2$ unif 0 1E9 output
1 $ANCNPOPTOT$ unif 0 1E9 output
1 $TDIV1$ unif 100 1E7 output
1 $TMIG$ unif 100 1E7 output
0 $MIG$ logunif 1E-100 1E-01 output
0 $MIG1$ logunif 1E-100 1E-01 output

[RULES]
$TMIG$ <= $TDIV1$

[COMPLEX PARAMETERS]
0 $RESIZE1$ = $ANCNPOP1$/$NPOP1$ output
0 $RESIZE2$ = $ANCNPOP2$/$NPOP2$ output
0 $RESIZE3$ = $ANCNPOPTOT$/$NPOP1$ output
```
Secondary contact initial est file:
```
// Priors and rules file
// *********************

[PARAMETERS]
//#isInt? #name #dist.#min #max
//all Ns are in number of haploid individuals
1 $NPOP1$ unif 0 1E9 output
1 $NPOP2$ unif 0 1E9 output
1 $ANCNPOP1$ unif 0 1E9 output
1 $ANCNPOP2$ unif 0 1E9 output
1 $ANCNPOPTOT$ unif 0 1E9 output
1 $TDIV1$ unif 100 1E7 output
1 $TMIG$ unif 100 1E7 output
0 $MIG$ logunif 1E-100 1E-01 output
0 $MIG1$ logunif 0 0 output

[RULES]
$TMIG$ <= $TDIV1$

[COMPLEX PARAMETERS]
0 $RESIZE1$ = $ANCNPOP1$/$NPOP1$ output
0 $RESIZE2$ = $ANCNPOP2$/$NPOP2$ output
0 $RESIZE3$ = $ANCNPOPTOT$/$NPOP1$ output
```
Ancestral migration initial est file:
```
// Priors and rules file
// *********************

[PARAMETERS]
//#isInt? #name #dist.#min #max
//all Ns are in number of haploid individuals
1 $NPOP1$ unif 0 1E9 output
1 $NPOP2$ unif 0 1E9 output
1 $ANCNPOP1$ unif 0 1E9 output
1 $ANCNPOP2$ unif 0 1E9 output
1 $ANCNPOPTOT$ unif 0 1E9 output
1 $TDIV1$ unif 100 1E7 output
1 $TMIG$ unif 100 1E7 output
0 $MIG$ logunif 0 0 output
0 $MIG1$ logunif 1E-100 1E-01 output

[RULES]
$TMIG$ <= $TDIV1$

[COMPLEX PARAMETERS]
0 $RESIZE1$ = $ANCNPOP1$/$NPOP1$ output
0 $RESIZE2$ = $ANCNPOP2$/$NPOP2$ output
0 $RESIZE3$ = $ANCNPOPTOT$/$NPOP1$ output
```
Strict isolation est file:
```
// Priors and rules file
// *********************

[PARAMETERS]
//#isInt? #name #dist.#min #max
//all Ns are in number of haploid individuals
1 $NPOP1$ unif 0 1E9 output
1 $NPOP2$ unif 0 1E9 output
1 $ANCNPOP1$ unif 0 1E9 output
1 $ANCNPOP2$ unif 0 1E9 output
1 $ANCNPOPTOT$ unif 0 1E9 output
1 $TDIV1$ unif 100 1E7 output
1 $TMIG$ unif 100 1E7 output
0 $MIG$ logunif 0 0 output
0 $MIG1$ logunif 0 0 output

[RULES]
$TMIG$ <= $TDIV1$

[COMPLEX PARAMETERS]
0 $RESIZE1$ = $ANCNPOP1$/$NPOP1$ output
0 $RESIZE2$ = $ANCNPOP2$/$NPOP2$ output
0 $RESIZE3$ = $ANCNPOPTOT$/$NPOP1$ output
```
The final scenario we want to model needs a different tpl and est file. This scenario is "single population" i.e. we are only modeling population size changes and considering N and S as panmictic.  
single population tpl file:  
```
//Parameters for the coalescence simulation program : fastsimcoal.exe
2 samples to simulate :
//Population effective sizes (number of genes)
$NPOP1$
$NPOP2$
//Samples sizes and samples age
42
12
//Growth rates : negative growth implies population expansion
0
0
//Number of migration matrices : 0 implies no migration between demes
3
//Migration matrix 0
0 $MIG$
$MIG$ 0
//Migration matrix 1
0 $MIG1$
$MIG1$ 0
//Migration matrix 2
0 0
0 0
//historical event: time, source, sink, migrants, new deme size, growth rate, migr mat index
3 historical event
0 0 1 1 2 0 1
$TMIG$ 0 0 1 $RESIZE2$ 0 1
$TDIV1$ 0 0 1 $RESIZE3$ 0 2
//Number of independent loci [chromosome]
1
//Per chromosome: Number of contiguous linkage Block: a block is a set of contiguous loci
1
//per Block:data type, number of loci, per gen recomb and mut rates
FREQ 1 0 1.18E-08
```
single population est file:  
```
// Priors and rules file
// *********************

[PARAMETERS]
//#isInt? #name #dist.#min #max
//all Ns are in number of haploid individuals
1 $ANCNPOP1$ unif 0 1E9 output
1 $ANCNPOP2$ unif 0 1E9 output
1 $ANCNPOPTOT$ unif 0 1E9 output
1 $TDIV1$ unif 100 1E7 output
1 $TMIG$ unif 100 1E7 output
0 $MIG$ logunif 0 0 output
0 $MIG1$ logunif 0 0 output

[RULES]
$TMIG$ <= $TDIV1$

[COMPLEX PARAMETERS]
0 $NPOP1$ = $ANCNPOP1$/2
0 $NPOP2$ = $ANCNPOP1$/2
0 $RESIZE2$ = $ANCNPOP2$/$NPOP1$ output
0 $RESIZE3$ = $ANCNPOPTOT$/$NPOP1$ output
```

These files then will next be used to figure out the best likelihoods of our various scenarios (https://github.com/laninsky/bats_and_rats/tree/master/fastsimcoal2_optimising).
