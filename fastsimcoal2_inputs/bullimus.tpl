//Parameters for the coalescence simulation program : fastsimcoal.exe
2 samples to simulate :
//Population effective sizes (number of genes)
$NPOP1$
$NPOP2$
//Samples sizes and samples age
12
14
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
