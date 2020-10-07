After determining the most likely scenario, and calculating its 'final' likelihood in the `likelihood_run` folder (https://github.com/laninsky/bats_and_rats/tree/master/fastsimcoal2_optimising), the next step is determining the uncertainty around parameter estimates for the most likely scenario using parameteric bootstrapping.

First we need to create a folder to hold all our bootstrap replicates, and copy over the \*.par file of the most likely run, and the \*.est and \*.tpl files that led to this most likely scenario.
```
mkdir bootstrapping
cp likelihood_run/haplo_ongoing_migration.par bootstrapping/
cp 1/haplo_ongoing_migration.est bootstrapping/
cp 1/haplo_ongoing_migration.tpl bootstrapping/
cp 1/haplo_ongoing_migration_MSFS.obs bootstrapping/
```

After copying over the par file from the `likelihood_run` folder, this file needs to be modified to generate `DNA` data rather than `FREQ`. This will use information on the number of loci and average length of these loci generated back in https://github.com/laninsky/bats_and_rats/tree/master/fastsimcoal2_inputs. In this case, the number of loci is `16376` and the average length of loci is `91`.  

bootstrap par file:
```
//Parameters for the coalescence simulation program : fastsimcoal.exe
2 samples to simulate :
//Population effective sizes (number of genes)
610274
485245
//Samples sizes and samples age
42
12
//Growth rates : negative growth implies population expansion
0
0
//Number of migration matrices : 0 implies no migration between demes
3
//Migration matrix 0
0 7.88838e-06
7.88838e-06 0
//Migration matrix 1
0 0.000121469
0.000121469 0
//Migration matrix 2
0 0
0 0
//historical event: time, source, sink, migrants, new deme size, growth rate, migr mat index
3 historical event
32327 0 0 1 3.44108e-05 0 1
32327 1 1 1 969.2103288 0 1
5752069 0 1 1 1204.0621885 0 2
//Number of independent loci [chromosome]
16376
//Per chromosome: Number of contiguous linkage Block: a block is a set of contiguous loci
1
//per Block:data type, number of loci, per gen recomb and mut rates
DNA 91 0 1.18E-08 OUTEXP
```
The replicate SFS files will then be generated using the following code
```
#!/bin/bash -e
#SBATCH -A uoo03004
#SBATCH -J haplo_ongoing_migration
#SBATCH -t 6:00:00
#SBATCH --mem=5GB
#SBATCH -c 12
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -D /nesi/nobackup/uoo03004/bats_rats/haplo_ongoing_migration/bootstrapping

/nesi/nobackup/uoo03004/bats_rats/fsc26_linux64/fsc26 -i haplo_ongoing_migration.par -n 100 -m --multiSFS -q -c 24 -B 24 -x -j -s0 > ${MOAB_JOBARRAYINDEX}.log
```
We then need to copy the \*.est and \*.tpl files into each of the 100 folders (which are located within a folder called `haplo_ongoing_migration`):  
```
for i in `seq 1 100`;
  do cp haplo_ongoing_migration.est haplo_ongoing_migration/haplo_ongoing_migration_${i}/;
  cp haplo_ongoing_migration.tpl haplo_ongoing_migration/haplo_ongoing_migration_${i}/;
done
```
We then need to copy/modify the `fastsimcoal.sh` script we'll use for each of the bootstrap replicates to run the 50 replicates for estimating the parameters that result in the highest likelihood for each replicate (this means 500 jobs in total: 100 bootstraps * 50 fastsimcoal replicate runs), and launch it. The template script and the loop to launch all the jobs should be located in the `bootstrapping` parent folder. 

fastsimcoal.sh template:
```
#!/bin/bash -e
#SBATCH -A uoo03004
#SBATCH -J haplo_ongoing_migration
#SBATCH -t 6:00:00
#SBATCH --mem=5GB
#SBATCH -c 12
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -D 
#SBATCH --array=1-50

mkdir fastsimcoal_${SLURM_ARRAY_TASK_ID}
cp haplo_ongoing_migration.est fastsimcoal_${SLURM_ARRAY_TASK_ID}/
cp haplo_ongoing_migration.tpl fastsimcoal_${SLURM_ARRAY_TASK_ID}/
cp haplo_ongoing_migration_MSFS.obs fastsimcoal_${SLURM_ARRAY_TASK_ID}/
cd fastsimcoal_${SLURM_ARRAY_TASK_ID}
/nesi/nobackup/uoo03004/bats_rats/fsc26_linux64/fsc26 -t haplo_ongoing_migration.tpl -e haplo_ongoing_migration.est -n 100000 -m -M --multiSFS -L 40 -q -c 24 -B 24 -x > ${MOAB_JOBARRAYINDEX}.log
```
Loop to launch fastsimcoal2 jobs for each of the bootstrap replicates. Due to computational limits, had to increment the number of replicates in lots of 20 (replacing the ```for i in `seq 1 20` ```line): 
```
for i in `seq 1 20`;
  do head -n 8 fastsimcoal.sh > haplo_ongoing_migration/haplo_ongoing_migration_${i}/fastsimcoal.sh;
  directory_start=`head -n 9 fastsimcoal.sh | tail -n 1`;
  echo $directory_start "/nesi/nobackup/uoo03004/bats_rats/haplo_ongoing_migration/bootstrapping/haplo_ongoing_migration/haplo_ongoing_migration_${i}/" >> haplo_ongoing_migration/haplo_ongoing_migration_${i}/fastsimcoal.sh;
  tail -n 8 fastsimcoal.sh >> haplo_ongoing_migration/haplo_ongoing_migration_${i}/fastsimcoal.sh;
  sbatch haplo_ongoing_migration/haplo_ongoing_migration_${i}/fastsimcoal.sh;
done
```
Once all the bootstrap replicates are done, we need to summarize the likelihoods from each of the replicates. Our directory structure looks like this:
```
bootstrapping
--> haplo_ongoing_migration
----> haplo_ongoing_migration_1...100
------> fastsimcoal_1...50
--------> haplo_ongoing_migration
---------->  haplo_ongoing_migration.brent_lhoods
```
From within the `bootstrapping` parent folder, we run:  
```
for j in `seq 1 100`;
  do for i in haplo_ongoing_migration/haplo_ongoing_migration_${j}/fastsimcoal_*; 
    do grep -v "^$" $i/*/*.brent_lhoods | grep -v "\-\-\-\-\-" | grep -v "nan" | sort -nk 14 | tail -n 2 | head -n 1 >> haplo_ongoing_migration/haplo_ongoing_migration_${j}/temp;
  done;
  sort -rnk 14 haplo_ongoing_migration/haplo_ongoing_migration_${j}/temp | head -n 1 >> likelihoods.txt;
done
```
