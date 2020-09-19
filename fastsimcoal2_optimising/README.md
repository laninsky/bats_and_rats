After getting fastsimcoal2 files together (https://github.com/laninsky/bats_and_rats/tree/master/fastsimcoal2_inputs), a folder was created for each species + scenario.
```
mkdir haplo_ongoing_migration
```
Within this folder, a folder to hold the initial 50 replicates was created:
```
cd haplo_ongoing_migration
mkdir 1
```
Within this folder, the tpl, est, and SFS files appropriate to that species/scenario were copied, and named consistently in order for fastsimcoal2 to find the SFS file
```
cd 1
cp ../../output/fastsimcoal2/vcf_w_monomorphic_MSFS.obs haplo_ongoing_migration_MSFS.obs
cp ../../fastsimcoal.tpl haplo_ongoing_migration.tpl
cp ../../ongoing_migration.est haplo_ongoing_migration.est
```
The bash script to generate the initial 50 simulations:
```
#!/bin/bash -e
#SBATCH -A uoo03004
#SBATCH -J haplo_ongoing_migration
#SBATCH -t 6:00:00
#SBATCH --mem=5GB
#SBATCH -c 12
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -D /nesi/nobackup/uoo03004/bats_rats/haplo_ongoing_migration/1
#SBATCH --array=1-50

mkdir fastsimcoal_${SLURM_ARRAY_TASK_ID}
cp haplo_ongoing_migration.est fastsimcoal_${SLURM_ARRAY_TASK_ID}/
cp haplo_ongoing_migration.tpl fastsimcoal_${SLURM_ARRAY_TASK_ID}/
cp haplo_ongoing_migration_MSFS.obs fastsimcoal_${SLURM_ARRAY_TASK_ID}/
cd fastsimcoal_${SLURM_ARRAY_TASK_ID}
/nesi/nobackup/uoo03004/bats_rats/fsc26_linux64/fsc26 -t haplo_ongoing_migration.tpl -e haplo_ongoing_migration.est -n 100000 -m -M --multiSFS -L 40 -q -c 24 -B 24 -x > ${MOAB_JOBARRAYINDEX}.log
```
After the 50 replicates are done, the following code can be used to summarise the highest likelihood runs from within each replicate:
```
for i in fastsimcoal_*; do lineno=`wc -l $i/*/*.brent_lhoods | awk '{print $1}'`; lineno=$(( lineno - 1 )); tail -n $lineno $i/*/*.brent_lhoods | sed '/^$/d' | sort -nk 13 | tail -n 1 >> temp; done
sort -rnk 14 temp > likelihoods.txt
rm temp
```
We then see whether the best likelihood replicate in the current set of 50 has a higher likelihood than the previous set of 50 replicates (if so, we are still trending towards finding more likely solutions and will continue on). This example is to compare folder `1` and `2` from the parent folder:
```
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
```
If "Likelihood still increasing, keep going" is the case, we will also generate a new est file based on the parameter estimates across the previous 50 runs:
```
Rscript generate_new_est.R
```
If "No further increase in likelihood detected. Safe to stop" is the case, we need to compare to the `.est` folder of the initial run (e.g. folder `1`), to make sure that the parameter estimates for the replicate with the highest likelihood were not within two orders of magnitude of the low end of the initial search range distribution, or exceeded the upper end of the initial search range. If so, a new set of replicates will need to be initiated where the search range for each parameter ranges from two orders of magnitude smaller than the minimum estimate across the 50 replicates that included the replicate with the highest likelihood, to the maximum across those replicates. Run in the parent folder.
```
# Modify the paths to the folders of interest at the beginning of initial_search_range.R
Rscript initial_search_range.R
```
