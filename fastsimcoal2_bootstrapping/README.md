After determining the most likely scenario, and calculating its 'final' likelihood in the `likelihood_run` folder (https://github.com/laninsky/bats_and_rats/tree/master/fastsimcoal2_optimising), the next step is determining the uncertainty around parameter estimates for the most likely scenario using parameteric bootstrapping.

First we need to create a folder to hold all our bootstrap replicates, and copy over the \*.par file of the most likely run, and the \*.est and \*.tpl files that led to this most likely scenario.
```
mkdir bootstrapping
cp likelihood_run/haplo_ongoing_migration.par bootstrapping/
cp 1/haplo_ongoing_migration.est bootstrapping/
cp 1/haplo_ongoing_migration.tpl bootstrapping/
cp 1/haplo_ongoing_migration_MSFS.obs bootstrapping/
```

After copying over the par file from the `likelihood_run` folder, this file needs to be modified to generate `DNA` data rather than `FREQ`.

-j option to output into separate folders
-s0 to output the data as DNA
