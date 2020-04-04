#quantify gene expression using featureCounts

#count reads

featureCounts -s 2 -p -a ./hg19_chr22_ref/hg19_chr22.gtf -o SRR1041710_counts.txt SRR1041710Aligned.sortedByCoord.out.bam

#clean count table

cut -f1,7 SRR1041710_counts.txt|grep -v "#" > SRR1041710_counts_table.txt

#merge count tables to generate read count matrix

paste *_counts_table.txt | cut -f1,2,4,6,8,10,12 |sed 's/Aligned.sortedByCoord.out.bam//g' >quant_count.txt
