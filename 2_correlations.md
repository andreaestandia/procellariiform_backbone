# Exploring the relationships between substitution rates, body size and life history traits

To explore the relationships between substitution rates, body size, life history traits and population size I used COEVOL1.4b. All input/output files should be available in Supplementary Data. 

* `-d` : input alignment
* `-t` : uncalibrated tree
* `-cal` : calibrations
* `-c`: traits

**Subset 1**: All variables and an alignment with random UCEs

``` 
nohup ./coevol -f -d coevol_alignment.nex -t exabayes_unpartitioned_75.tre -fixbl -c all_vars.csv all_vars &
```

**Subset 2**: Only AFB and body size and an alignment with random UCEs

```
nohup ./coevol -f -d coevol_alignment.nex -t exabayes_unpartitioned_75.tre -fixbl -c afb_body.csv afb_body &
```

**Subset 3**: All variables and an alignment with only UCE with high GC content

```
nohup ./coevol -f -d coevol_high_gc.phy -t exabayes_tree.tre -fixbl -c all_vars.csv -gc high_gc &
```

**Subset 4**: All variables and an alignment with only UCE with low GC content

```
nohup ./coevol -f -d coevol_low_gc.phy -t exabayes_tree.tre -fixbl -c all_vars.csv -gc low_gc &
```

### Create high and low GC content subsets

Calculate GC content per locus using my custom script:

```
import os
import csv

PATH = "/ddn/data/xnvd74/seabird_project/Backbone/uce-analysis/gc"


# Prepare metadata
summary_files = [file for file in os.listdir(PATH) if file.endswith('.out')]


dic = {}
for index, out in enumerate(summary_files):
    summary_file = open(os.path.join(PATH, out), 'r')
    data = [x.strip().split('\t') for x in summary_file.readlines()][1]
    mat_cells = int(data[3])
    c = int(data[13])
    g = int(data[14])
    dic[data[0]] = (c+g)/mat_cells


with open("GC.txt", "w") as f:
    writer = csv.writer(f, dialect="excel-tab")
    for key, value in dic.items():
        writer.writerow((key, value))
```

Concatenate the top 10% and bottom 10% using AMAS (https://github.com/marekborowiec/AMAS):

``` 
python AMAS.py concat -i low_gc.phylip -f phylip -u phylip -d dna
```

``` 
python AMAS.py concat -i high_gc.phylip -f phylip -u phylip -d dna
```

