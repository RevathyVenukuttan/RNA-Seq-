# RNA-Seq-for-Differential-Expression

In this project, a differential expression analysis of RNA-seq data is conducted to compare the expression levels of undifferentiated stems cells and dopaminergic neuron precursors (DA progenitors). 

The data is in FASTQ format with 12 fastq files which are corresponding to 2 different cell types (undifferentiated stem cell & dopaminergic neuron precursor), each of them having 3 biological replicates which are paired end sequenced (2 cell types x 3 replicates x 2 pairs). The data for this project has been subsetted to just the reads mapping to hg19 chromosome 22 (chr22), to limit data sizes and memory usage. 

These data were published by Gonzalez et al., and the original raw files are available on the Gene Expression Omnibus (GEO), ID GSE52912:
https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE52912

Gonzalez R, Garitaonandia I, Crain A, Poustovoitov M et al. Proof of concept studies exploring the safety and functional activity of human parthenogenetic-derived neural stem cells for the treatment of Parkinson's disease. Cell Transplant 2015;24(4):681-90. PMID: 25839189

Since these data are for human chr22 only, just the chr22 fasta sequence is used as a reference (we will use the sequences for human reference version hg19).

## Indexing the reference

STAR uses an index to efficiently map reads. It must be built once for each genome to be used and takes GTF file as input when creating the genome index, so that it is aware of known splice junctions. 

The script is given in **index_genome.sh**

## Quality Control Reports

This step ensures to check the raw data quality in the fastq files. Find the script in **fastQC.sh**

## Alignment

First step in this process is to map short reads to the reference genome. 

```bash
cd ~/bioinfo/bioe582/1_rnaseq
STAR --genomeDir ./hg19_chr22_ref --runThreadN 1 --readFilesCommand zcat --readFilesIn SRR1041710_chr22_R1.fastq.gz SRR1041710_chr22_R2.fastq.gz --outFileNamePrefix SRR1041710 --outSAMtype BAM SortedByCoordinate
``` 
This command can be used for the first RNA-seq sample and has to be repeated for the next 5 samples. Instead by using the script given in **Alignment.sh** would enable automatically generate alignment commands for all the files. The scripts in the mentioned file also covers the steps of indexing the mapped .bam files, counting alignments and removing duplicates.

## Quantify Gene Expression

The entire process of quantifying gene expression consists of the following steps: Count the number of reads in each annotation using featureCounts(), clean the count table and then merge all the count tables together to generate a raw read count matrix. 
The script is given in **gene_quant.sh**

## Differential Expression Analysis

This step is performed in R-studio using the edgeR() library from BioConductor. The gene expression quantified as raw counts for all samples are used to identify the differential expression and further normalize the expression levels using counts-per-million mormalization. Script is available in **DE_analysis.R**
