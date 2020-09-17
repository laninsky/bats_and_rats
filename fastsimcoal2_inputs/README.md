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
head -n 3 vcf_w_monomorphic_MSFS.obs | tail -n 1 | bc
```

