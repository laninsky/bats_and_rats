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

-j option to output into separate folders
-s0 to output the data as DNA


1488884 total sites
91 bp in average
