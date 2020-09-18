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
