# Phylogenetic analyses

## Partitioning 

```
path=/ddn/data/xnvd74/seabird_project/Backbone/uce-analysis/
```

### Scheme one (each locus as a partition) + PartitionFinder

First create a folder where you should have your config file (see PartitionFinder manual) and an alignment. In my case, these files are in a folder named “Partitioning”. We set the rcluster-max argument as 5000.

```
python PartitionFinder.py $path/Partitioning --raxml --rcluster-max 5000
```

### Scheme two (Entropy-based automatic partitioning with SWSC-EN) + PartitionFinder

SWSC-EN only needs a single input file, which is a concatenated nexus alignment (.nex) comprised of UCE markers and including charsets with the locations of the UCEs

```
python SWSCEN.py $path/alignments/cleaned-alignments/subset-Gblocks-clean-75p-raxml/subset-Gblocks-cleaned-75p.nex
```

The output is a config file for PartitionFinder which we can put in a folder and run it directly with the same parameters as above. For more information about the specific parameters refer to the supplementary data.

``` 
​```
python PartitionFinder.py $path/Partitioning_SWSC --raxml --rcluster-max 5000
​```
```

## RAxML

I ran RAxML with the 75%, 85% and 95% matrices under the GTR and GTR+G models. For the 75% matrix I also ran a partitioned analysis with the charsets produced using scheme 2.

```
path=/ddn/data/xnvd74/seabird_project/Backbone/uce-analysis/alignments/cleaned-alignments/subset-Gblocks-clean-75p-raxml/

#75% matrix - GTR and GTR+G
raxmlHPC-PTHREADS-SSE3 -N autoMRE -m GTRGAMMA -x $RANDOM -p $RANDOM -s $path/alignments/cleaned-alignments/subset-Gblocks-clean-75p-raxml/subset-Gblocks-cleaned-75p.phylip -T 40 -n 75_GTRGAMMA &

raxmlHPC-PTHREADS-SSE3 -N autoMRE -m GTR -x $RANDOM -p $RANDOM -s $path/alignments/cleaned-alignments/subset-Gblocks-clean-75p-raxml/subset-Gblocks-cleaned-75p.phylip -T 40 -n 75_GTR &

#The same for the 85% and 95% matrix.
#Run again the 75% with the flag -q and the partitions file produced by SWSC-EN

```

## Exabayes

I ran two analyses: i) a partitioned analysis with the charsets produced by scheme 1 and the 95% matrix

```
mpirun -np 20 exabayes -f $path/alignments/cleaned-alignments/subset-Gblocks-clean-95p-raxml/subset-Gblocks-cleaned-95p.phylip -q aln.part -s $RANDOM -m DNA -n exabayes_partitioned_95 -c config.nexus &
```

ii) an unpartitioned analysis with the 75% matrix. 

```
mpirun -np 20 exabayes -f $path/alignments/cleaned-alignments/subset-Gblocks-clean-75p-raxml/subset-Gblocks-cleaned-75p.phylip -s $RANDOM -m DNA -n exabayes_unpartitioned_75 -c config.nexus &
```

## IQ Tree

```
./iqtree -s $path/alignments/cleaned-alignments/subset-Gblocks-clean-75p-raxml/subset-Gblocks-cleaned-75p.phylip -spp $path/PartitionFinder/analysis/input_RAxML.txt
input_RAxML.txt -bb 1000 -nt 20
```

## Species tree analysis

`raxml.pl` is a modified RAxML wrapper that can be found in the code folder. The flag –seqdir indicates the path to a folder where you can find a nexus file per locus. –raxmldir indicates the output directory for the raxml runs and –astraldir for ASTRAL output

```
raxml.pl --seqdir=/ddn/data/xnvd74/seabird_project/Backbone/uce-analysis/Genetree/input-nexus --raxmldir=raxml --astraldir=$path/astral/astral_all
raxml.pl --seqdir=$path/Genetree/input-nexus/top10 --raxmldir=raxml --astraldir=$path/astral/astral_top10
```

To summarise the trees produced by ASTRAL, I used sumtree.py, within the package DentroPy

``` 
python sumtrees.py --burnin=200 --output-tree-filepath=astral.tre $path/astral/astral_all/*
python sumtrees.py --burnin=200 --output-tree-filepath=astral_top10.tre $path/astral/top10/*
```

## BEAST

To select a random subset of UCEs (~20,000 bp) and concatenate them:

```
#Create 100 lists with random UCEs
for i in {1..100}
do
	ls |sort -R |tail -30 > list_${i}.txt
done
#Concatenate the elements of those lists into a 
for i in list*;
do
	python $path/scripts/AMAS.py concat -i * -f nexus -d dna 
done

```

Open BEAUTI and manually set priors+clock+other parameters for each subset

Run BEAST

### Summarization of Posterior Probabilities of Clades with a Maximum Clade Credibility Tree (MCCT)

Summarise a set of trees

```
sumtrees.py --summary-target=mcct --burnin=200 --support-as-labels --output-tree-filepath=consensus_strict.tre *.tre
```

### Calculate GC content

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

