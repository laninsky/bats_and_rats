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
We then see whether the best likelihood replicate in the current set of 50 has a higher likelihood than the previous set of 50 replicates (if so, we are still trending towards finding more likely solutions and will continue on:
```
```
If this is the case, we will also generate a new est file based on the parameter estimates across the previous 50 runs:
```
Rscript generate_new_est.R
```
