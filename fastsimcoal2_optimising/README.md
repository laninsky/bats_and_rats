After getting fastsimcoal2 files together (https://github.com/laninsky/bats_and_rats/tree/master/fastsimcoal2_inputs), a folder was created for each species + scenario.
```
mkdir haplo/haplo_ongoing_migration
mkdir bullimus/bullimus_ongoing_migration
mkdir haplo/haplo_ancestral_migration
mkdir bullimus/bullimus_ancestral_migration
mkdir haplo/haplo_secondary_contact
mkdir bullimus/bullimus_secondary_contact
mkdir haplo/haplo_strict_isolation
mkdir bullimus/bullimus_strict_isolation
mkdir haplo/haplo_single_population
mkdir bullimus/bullimus_single_population

```
Within each of these folders, a folder to hold the initial 50 replicates was created:
```
# e.g.
cd bullimus_ancestral_migration
mkdir 1
```
Within this folder, the tpl, est, and SFS files appropriate to that species/scenario were copied, and named consistently in order for fastsimcoal2 to find the SFS file
```
cd 1
cp ../../fastsimcoal2_inputs/output/fastsimcoal2/vcf_w_monomorphic_MSFS.obs bullimus_ancestral_migration_MSFS.obs
vi bullimus_ancestral_migration.tpl # copy from https://github.com/laninsky/bats_and_rats/blob/master/fastsimcoal2_inputs/bullimus.tpl
vi bullimus_ancestral_migration.est # copy from https://github.com/laninsky/bats_and_rats/blob/master/fastsimcoal2_inputs/ancestral_migration.est
```
This bash script was used to generate the initial 50 simulations for the scenarios:
```
#!/bin/bash -e
#SBATCH -A uoo03004
#SBATCH -J bullimus_ancestral_migration
#SBATCH -t 6:00:00
#SBATCH --mem=5GB
#SBATCH -c 12
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -D /nesi/nobackup/uoo03004/bats_rats/22Mar21/bullimus/bullimus_ancestral_migration/1
#SBATCH --array=1-50

fsc2_prefix=bullimus_ancestral_migration

mkdir fastsimcoal_${SLURM_ARRAY_TASK_ID}
cp $fsc2_prefix.est fastsimcoal_${SLURM_ARRAY_TASK_ID}/
cp $fsc2_prefix.tpl fastsimcoal_${SLURM_ARRAY_TASK_ID}/
cp ${fsc2_prefix}_MSFS.obs fastsimcoal_${SLURM_ARRAY_TASK_ID}/
cd fastsimcoal_${SLURM_ARRAY_TASK_ID}
/nesi/nobackup/uoo03004/bats_rats/fsc26_linux64/fsc26 -t $fsc2_prefix.tpl -e $fsc2_prefix.est -n 100000 -m -M --multiSFS -L 40 -q -c 24 -B 24 -x > fastsimcoal.log
```

After the 50 replicates are done, the following code can be used to summarise the highest likelihood runs from within each replicate:
```
# For two population scenarios
for i in fastsimcoal_*; do grep -v "^$" $i/*/*.brent_lhoods | grep -v "\-\-\-\-\-" | grep -v "nan" | sort -nk 14 | tail -n 2 | head -n 1 >> temp; done
sort -rnk 14 temp > likelihoods.txt
rm temp

# For the single population scenario
for i in fastsimcoal_*; do grep -v "^$" $i/*/*.brent_lhoods | grep -v "\-\-\-\-\-" | grep -v "nan" | sort -nk 13 | tail -n 2 | head -n 1 >> temp; done
sort -rnk 13 temp > likelihoods.txt
rm temp
```
Within folder `1`, we generate a new est file based on the parameter estimates found across the 50 replicates, and copy that over to folder `2` to run another 50 replicates (our aim is to see whether narrowing our search range allows us to find a more likely set of parameter values), along with the other necessary files (the SFS, the tpl file, the batch script)
```
# For two population scenarios
Rscript generate_new_est.R

# For the single population scenario
Rscript generate_new_est_single.R
```
We then see whether the best likelihood replicate in the current set of 50 has a higher likelihood than the previous set of 50 replicates (if so, we are still trending towards finding more likely solutions and will continue on). This example is to compare folder `1` and `2` from the parent folder:
```
# For two population scenarios
previous=1
current=2
previous_best=`head -n 1 $previous/likelihoods.txt | awk '{print $14}'`
current_best=`head -n 1 $current/likelihoods.txt | awk '{print $14}'`
echo "Previous best is" $previous_best
echo "Current best is" $current_best

if (( $(echo "$previous_best > $current_best" |bc -l) ))
  then
    echo "No further increase in likelihood detected. Safe to stop"
  else   
    echo "Likelihood still increasing, keep going"
fi

# For the single population scenario
previous=1
current=2
previous_best=`head -n 1 $previous/likelihoods.txt | awk '{print $13}'`
current_best=`head -n 1 $current/likelihoods.txt | awk '{print $13}'`
echo "Previous best is" $previous_best
echo "Current best is" $current_best

if (( $(echo "$previous_best > $current_best" |bc -l) ))
  then
    echo "No further increase in likelihood detected. Safe to stop"
  else   
    echo "Likelihood still increasing, keep going"
fi
```
If "Likelihood still increasing, keep going" is the case, we will also generate a new est file based on the parameter estimates across the previous 50 runs, copy over the files, and keep going (e.g. create a `3` folder, and then a `4` folder if still getting the same message etc etc):
```
# For two population scenarios
Rscript generate_new_est.R

# For the single population scenario
Rscript generate_new_est_single.R
```
If "No further increase in likelihood detected. Safe to stop" is the case, we need to compare to the `.est` folder of the initial run (e.g. folder `1`, or the folder you put the est file into after running `initial_search_range.R` last time around), to make sure that the parameter estimates for the replicate with the highest likelihood were not within two orders of magnitude of the low end of the initial search range distribution, or exceeded the upper end of the initial search range (to make sure our search range isn't potentially constraining our results). Tweak the paths to the relevant folder and run in the parent folder:  
```
# Modify the paths to the folders of interest at the beginning of initial_search_range.R
# For two population scenarios
Rscript initial_search_range.R

# For the single population scenario
Rscript initial_search_range_single.R
```
If you get the following message, "Some parameter estimates are greater than the upper bound of the initial search range or within two orders of magnitude of the lower bound of the initial search range. A new est file has been written out to start again", first double check that this message is not due to the lower search bound being 0! (because no matter how many times you go through this process, if the parameter estimates that lead to the best likelihood are below 100, you'll never get more than two orders of magnitude above the lower bound). If this is the case, skip down to the instructions for what to do if "No parameter estimate is greater than the upper bound of the initial search range nor within two orders of magnitude of the lower bound of the initial search range".
 
However, if lower bound = 0 isn't the cause, a new set of replicates will need to be initiated where the search range for each parameter ranges from two orders of magnitude smaller than the minimum estimate across the 50 replicates that included the replicate with the highest likelihood, to the maximum across those replicates. This est file will have been generated by the initial_search_range.R code. You need to go through the motions of Line 10 onwards again, using this new est file. Once you hit the "likelihood plateau" in this set of runs, compare to the best likelihood from the initial est files. If the intial est files led to the run with the best likelihood, this best likelihood is the one to proceed to final likelihood estimation with. If not, you'll need to compare your most likely run from this set of replicates to the new est file created at the start of this round of replicates using `initial_search_range.R` (don't forget to tweak the paths to your folders).

Onc you get to "No parameter estimate is greater than the upper bound of the initial search range nor within two orders of magnitude of the lower bound of the initial search range. Good to go!", then the following code can be used to generate a \*.par file with the parameters that led to the highest likelihood.
```
# cd into the folder with the highest likelihood run
cd 1

# For two population scenarios
Rscript generate_par_file.R

# For the single population scenario
Rscript generate_par_file_single.R
```
The par file that lead to the highest likelihood run can then be copied out to re-run for 50 additional runs with -n = 1,000,000 to estimate the likelihood more accurately for selecting the best fitting scenario with AIC.
```
mkdir likelihood_run
cp 1/haplo_ongoing_migration_MSFS.obs likelihood_run/
cp 1/haplo_ongoing_migration.par likelihood_run/

#!/bin/bash -e
#SBATCH -A uoo03004
#SBATCH -J haplo_ongoing_migration
#SBATCH -t 6:00:00
#SBATCH --mem=5GB
#SBATCH -c 12
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -D /nesi/nobackup/uoo03004/bats_rats/haplo_ongoing_migration/likelihood_run
#SBATCH --array=1-50

mkdir fastsimcoal_${SLURM_ARRAY_TASK_ID}
cp haplo_ongoing_migration.par fastsimcoal_${SLURM_ARRAY_TASK_ID}/
cp haplo_ongoing_migration_MSFS.obs fastsimcoal_${SLURM_ARRAY_TASK_ID}/
cd fastsimcoal_${SLURM_ARRAY_TASK_ID}
/nesi/nobackup/uoo03004/bats_rats/fsc26_linux64/fsc26 -i haplo_ongoing_migration.par -n 1000000 -m --multiSFS -L 40 -q -c 24 -B 24 -x > fastsimcoal.log
```
After the final likelihood run is completed, the "best" likelihood for the run can be summarized by:
```
for i in fastsimcoal_*; do grep -v "^$" $i/*/*.lhoods | tail -n 1 >> temp; done
sort -rnk 1 temp > likelihoods.txt
rm temp
```
When summarizing the final outputs, note that NPOP1 refers to S in Haplo, and N in Bullimus due to how easySFS sets up SFS files based on sample order in the population file. The final likelihoods for each scenario can then be used with AIC to chose the optimal demographic scenario. With this optimal scenario, uncertainty can be modeled using bootstrapping (https://github.com/laninsky/bats_and_rats/tree/master/fastsimcoal2_bootstrapping).
