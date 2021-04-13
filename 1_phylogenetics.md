# Phylogenetic analyses

##### Andrea Estandia - andrea.estandia@zoo.ox.ac.uk

All necessary files for reproducing the results are available at [NNNN]. You are very welcome to contact me if a line of code doesn’t work for you.

Necessary programs: 

* PartitionFinder (https://www.robertlanfear.com/partitionfinder/)
* SWSC-EN (https://github.com/Tagliacollo/PFinderUCE-SWSC-EN)
* RAxML (https://cme.h-its.org/exelixis/web/software/raxml/)
* ASTRAL  (https://github.com/smirarab/ASTRAL)
* Exabayes (https://cme.h-its.org/exelixis/web/software/exabayes)
* DendroPy (https://dendropy.org)
* IQTree (http://www.iqtree.org/)
* BEAST  (https://beast.community/)
* COEVOL 1.4b (https://megasun.bch.umontreal.ca/People/lartillot/www/downloadcoevol.html)

## Step 1: Partitioning 

I created two partitioning schemes. First, I applied a locus-partitioned scheme (partitioning scheme one), which uses each UCE as a separate partition with a potentially separate substitution model. Second, I employed an entropy-based partitioning scheme using SWSC-EN (partitioning scheme two; Tagliacollo and Lanfear 2018)⁠, which splits each UCE locus into 3 parts – the core and the two flanking regions, and allows different substitution models for each region of each UCE locus.

```bash
path=/ddn/data/xnvd74/seabird_project/Backbone/uce-analysis/
```

### Scheme one (each locus as a partition) + PartitionFinder

I created a folder where my config file and an alignment were. I set the rcluster-max argument as 5000. Find the input and output files in the `Partitioning` folder in Supplementary data 

```python
python PartitionFinder.py $path/Partitioning --raxml --rcluster-max 5000
```

### Scheme two (Entropy-based automatic partitioning with SWSC-EN) + PartitionFinder

SWSC-EN needs a single input file, which is a concatenated nexus alignment (.nex) comprised of UCE markers and charsets with the locations of the UCEs

```python
python SWSCEN.py $path/alignments/cleaned-alignments/subset-Gblocks-clean-75p-raxml/subset-Gblocks-cleaned-75p.nex
```

The output is a config file for PartitionFinder which I put in a folder and ran it directly with the same parameters as above. 

``` python
python PartitionFinder.py $path/Partitioning_SWSC --raxml --rcluster-max 5000
```

## Step 2: RAxML

I ran RAxML with the 75%, 85% and 95% matrices under the GTR and GTR+G models. For the 75% matrix I also ran a partitioned analysis with the charsets produced using scheme 2.

```bash
path=/ddn/data/xnvd74/seabird_project/Backbone/uce-analysis/alignments/cleaned-alignments/subset-Gblocks-clean-75p-raxml/

#75% matrix - GTR and GTR+G
raxmlHPC-PTHREADS-SSE3 -N autoMRE -m GTRGAMMA -x $RANDOM -p $RANDOM -s $path/alignments/cleaned-alignments/subset-Gblocks-clean-75p-raxml/subset-Gblocks-cleaned-75p.phylip -T 40 -n 75_GTRGAMMA &

raxmlHPC-PTHREADS-SSE3 -N autoMRE -m GTR -x $RANDOM -p $RANDOM -s $path/alignments/cleaned-alignments/subset-Gblocks-clean-75p-raxml/subset-Gblocks-cleaned-75p.phylip -T 40 -n 75_GTR &

#The same for the 85% and 95% matrix.
#Run again the 75% with the flag -q and the partitions file produced by SWSC-EN

```

## Step 3: Exabayes

I ran two analyses: i) a partitioned analysis with the charsets produced by scheme 1 and the 95% matrix

```bash
mpirun -np 20 exabayes -f $path/alignments/cleaned-alignments/subset-Gblocks-clean-95p-raxml/subset-Gblocks-cleaned-95p.phylip -q aln.part -s $RANDOM -m DNA -n exabayes_partitioned_95 -c config.nexus &
```

ii) an unpartitioned analysis with the 75% matrix (see that the unpartitioned analysis does not have the -q flag)

```
mpirun -np 20 exabayes -f $path/alignments/cleaned-alignments/subset-Gblocks-clean-75p-raxml/subset-Gblocks-cleaned-75p.phylip -s $RANDOM -m DNA -n exabayes_unpartitioned_75 -c config.nexus &
```

## Step 4: IQ Tree

I ran IQ-TREE v.1.6. (Nguyen et al. 2015; http//:iqtree.org/) with the 75% matrix and partitioning scheme 2. 

```bash
./iqtree -s $path/alignments/cleaned-alignments/subset-Gblocks-clean-75p-raxml/subset-Gblocks-cleaned-75p.phylip -spp $path/PartitionFinder/analysis/input_RAxML.txt
input_RAxML.txt -bb 1000 -nt 20
```

## Step 5: Species tree analysis

`raxml.pl` is a modified RAxML wrapper that can be found in the *src* folder. The flag –seqdir indicates the path to a folder where I had a nexus file per locus. –raxmldir indicates the output directory for the raxml runs and –astraldir for ASTRAL output

```bash
raxml.pl --seqdir=/ddn/data/xnvd74/seabird_project/Backbone/uce-analysis/Genetree/input-nexus --raxmldir=raxml --astraldir=$path/astral/astral_all
raxml.pl --seqdir=$path/Genetree/input-nexus/top10 --raxmldir=raxml --astraldir=$path/astral/astral_top10
```

To summarise the trees produced by ASTRAL, I used sumtree.py, within the package DentroPy

``` python
python sumtrees.py --burnin=200 --output-tree-filepath=astral.tre $path/astral/astral_all/*
python sumtrees.py --burnin=200 --output-tree-filepath=astral_top10.tre $path/astral/top10/*
```

## Step 6: BEAST

To select a random subset of UCEs (~20,000 bp) and concatenate them:

```
#Generate a set of 30 random UCEs and concatenate them 
for i in {1..100}
do
	ls |sort -R |tail -30 | python AMAS.py concat -i * -f phylip -u nexus -d dna -o subset${i}.nex
done
```

Within BEAUTI set priors+clock+other parameters for each subset

Run BEAST

Summarise a set of trees

```
sumtrees.py --summary-target=mcct --burnin=200 --support-as-labels --output-tree-filepath=consensus_strict.tre *.tre
```

## Step 7: Calculate GC content

Calculate GC content per locus and concatenate the top 10% and bottom 10% using AMAS

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

With these subsets I re-ran RAxML with the parameters above described above and concatenated them to run in Coevol 1.4b.

