# Exploring the relationships between substitution rates, body size and life history traits

To explore the relationships between substitution rates, body size, life history traits and population size I used COEVOL1.4b. All input/output files should be available in Supplementary Data. 

* `-d` : input alignment
* `-t` : uncalibrated tree
* `-cal` : calibrations
* `-c`: traits

**Subset 1**: All variables and an alignment with random UCEs

``` 
nohup ./coevol -f -d coevol_alignment.nex -t exabayes_unpartitioned_75.tre -cal calib.csv 61 61 -c all_vars.csv all_vars &
```

**Subset 2**: Only AFB and body size and an alignment with random UCEs

```
nohup ./coevol -f -d coevol_alignment.nex -t exabayes_unpartitioned_75.tre -cal calib.csv 61 61 -c afb_body.csv afb_body &
```

**Subset 3**: All variables and an alignment with only UCE with high GC content

```
nohup ./coevol -f -d coevol_high_gc.phy -t exabayes_tree.tre -cal calib.csv 61 61 -c all_vars.csv -gc high_gc &
```

**Subset 4**: All variables and an alignment with only UCE with low GC content

```
nohup ./coevol -f -d coevol_low_gc.phy -t exabayes_tree.tre -cal calib.csv 61 61 -c all_vars.csv -gc low_gc &
```

