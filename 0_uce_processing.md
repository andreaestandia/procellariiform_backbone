# UCE DATA ASSEMBLY

## Remove Illumina adapters - Trimmomatic

#### Define path

```
path=/ddn/data/xnvd74/seabird_project/Backbone/uce_analysis #main folder
raw=/ddn/data/xnvd74/seabird_project/Backbone/uce_analysis/raw #raw reads
cd $path 
mkdir cleaned #create a new dir for the trimmomatic analysis
```

#### Define the invariable parts of the illumina adapters

```
i51=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
i52=GTGTAGATCTCGGTGGTCGCCGTATCATT
i71=AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC
i72=ATCTCGTATGCCGTCTTCTGCTTG
```

### Iterate through the raw reads 

```
for file in *READ1.fastq.gz; do
	file2=$(echo $file | sed 's/-READ1/-READ2/')
	sample=$(echo $file | cut -d "-" -f1)
	mkdir $path/cleaned/$sample
	mkdir $path/cleaned/$sample/raw-reads
	mkdir $path/cleaned/$sample/split-adapter-quality-trimmed
	mkdir $path/cleaned/$sample/stats
	input=$raw
	output=$path/cleaned/$sample/split-adapter-quality-trimmed
	i5barcode=$(echo $(zcat $file | grep "^@J00" | cut -d ":" -f 10 | sort | uniq -c | sort -r | head -1 | sed -E 's/[0-9]+ [A-Z]+\+([A-Z]+)/\1/'))
	i7barcode=$(echo $(zcat $file | grep "^@J00" | cut -d ":" -f 10 | sort | uniq -c | sort -r | head -1 | sed -E 's/[0-9]+ ([A-Z]+)\+[A-Z]+/\1/'))
	i5=$i51$i5barcode$i52
	i7=$i71$i7barcode$i72
	i5revcomp=$(echo $i5 | rev | tr ATCG TAGC)
	i7revcomp=$(echo $i7 | rev | tr ATCG TAGC)
	cat $TruSeq3 > ../cleaned/$sample/adapters.fasta
	printf '\n'\>i5'\n'$i5'\n'\>i7'\n'$i7'\n'\>i5revcomp'\n'$i5revcomp'\n'\>i7revcomp'\n'$i7revcomp'\n' >> ../cleaned/$sample/adapters.fasta
	java -jar /ddn/apps/Cluster-Apps/miniconda2/4.3.27/jar/trimmomatic.jar PE -threads 8 -phred33 $input/$file $input/$file2 $output/$file $output/$sample\-READ1-single.fastq.gz $output/$file2 $output/$sample\-READ2-single.fastq.gz ILLUMINACLIP:$path/cleaned/$sample/adapters.fasta:2:30:10 LEADING:5 TRAILING:15 SLIDINGWINDOW:4:15 MINLEN:40 &> $path/cleaned/$sample/stats/$sample\-adapter-contam.txt
	cat $output/$sample\-READ1-single.fastq.gz > $output/$sample\-READ-singleton.fastq.gz
	cat $output/$sample\-READ2-single.fastq.gz >> $output/$sample\-READ-singleton.fastq.gz
	rm $output/$sample\-READ1-single.fastq.gz $output/$sample\-READ2-single.fastq.gz
done
	
```

## UCE contig assembly - Trinity

```
#!/bin/bash
#$ -V
#$ -cwd
#SBATCH -J trinity
#SBATCH -p par7.q
#SBATCH -n 120
#SBATCH -N 10 --ntasks-per-node=12
#SBATCH -o /ddn/data/xnvd74/seabird_project/Backbone/uce_analysis/log/array.log
#SBATCH -a 1-35%10

path=/ddn/data/sbvd77/UCE
FILE=$(sed "${SLURM_ARRAY_TASK_ID}q;d" $path/log/list_samples)

module load dbl/phyluce/1.5.0
export PATH=`echo ${PATH} | awk -v RS=: -v ORS=: '/jdk1.8.0/ {next} {print}'`

phyluce_assembly_assemblo_trinity --config $path/log/$(echo ${FILE} | cut -d ":" -f1).conf --output $path/assemblies --subfolder split-adapter-quality-trimmed --cores 12 --clean --log-path $path/log/trinity_log &> $path/oe_files/trinity$SLURM_ARRAY_TASK_ID.log
```

### Contigs to probes

```
phyluce_assembly_match_contigs_to_probes \
    --contigs $path/assemblies/contigs/ \
    --probes $path/probes/uce-5k-probes.fasta \
    --output $path/contigs_aligned_to_probes &> $path/log/match_contigs_to_probes.log
```

### Monolithic FASTA

```
phyluce_assembly_get_match_counts \
    --locus-db $path/contigs_aligned_to_probes/probe.matches.sqlite \
    --taxon-list-config $path/log/datasets.conf \
    --taxon-group 'dataset_out' \
    --output $path/match_counts/dataset_out.conf \
    --incomplete-matrix

phyluce_assembly_get_fastas_from_match_counts \
    --contigs $path/assemblies/contigs/ \
    --locus-db $path/contigs_aligned_to_probes/probe.matches.sqlite \
    --match-count-output $path/match_counts/dataset_out.conf \
    --incomplete-matrix $path/fastas_from_match_counts/dataset_out.incomplete \
    --output $path/fastas_from_match_counts/dataset_out.fasta
```

### Align UCE using MAFFT

```
phyluce_align_seqcap_align \
    --fasta $path/fastas_from_match_counts/dataset_out.fasta \
    --output $path/alignments/dataset_out/ \
    --output-format fasta \
    --taxa 52 \
    --aligner mafft \
    --no-trim \
    --cores 12 \
    --incomplete-matrix \
    --log-path $path/log/
```

### Gblocks trimming

```
phyluce_align_get_gblocks_trimmed_alignments_from_untrimmed \
    --alignments $path/alignments/dataset_out/ \
    --output $path/alignments/dataset_out_trimmed/ \
    --b4 8 \
    --cores 12 \
    --log-path $path/log/
```

### Contig dataset generation

#### Remove locus names

```
phyluce_align_remove_locus_name_from_nexus_lines \
    --alignments $path/alignments/dataset_out_trimmed \
    --output $path/alignments/dataset_out_trimmed_cleaned \
    --cores 12
```

#### Scripts to build the 75 and 95% contig datasets

```
phyluce_align_get_only_loci_with_min_taxa \
    --alignments $path/alignments/dataset_out_trimmed_cleaned \
    --taxa 54 \
    --percent 0.75 \
    --output $path/alignments/dataset_out_trimmed_cleaned_selected_75 \
    --cores 12 \
    --log-path $path/log

phyluce_align_get_only_loci_with_min_taxa \
    --alignments $path/alignments/dataset_out_trimmed_cleaned \
    --taxa 54 \
    --percent 0.95 \
    --output $path/alignments/dataset_out_trimmed_cleaned_selected_95 \
    --cores 12 \
    --log-path $path/log
```

### Summary statistics 

```
printf sample,contigs,total_bp,mean_length,95_CI_length,min_length,max_length,median_length,'contigs_>1kb''\n' > $path/log/get_fasta_lengths.tsv
for i in $path/assemblies/contigs/*.fasta;do
  phyluce_assembly_get_fasta_lengths --input $i --csv >> $path/log/get_fasta_lengths.tsv
done
```

