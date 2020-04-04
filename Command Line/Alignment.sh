#Alignment of short reads

#mapping short reads to reference genome

cd ~/bioinfo/bioe582/1_rnaseq
cd ~/bioinfo/bioe582/1_rnaseq
ls *_chr22_R1.fastq.gz | sed 's/_chr22_R1.fastq.gz//' |xargs -I {} echo "STAR --genomeDir ./hg19_chr22_ref --runThreadN 1 --readFilesCommand zcat --readFilesIn {}_chr22_R1.fastq.gz {}_chr22_R2.fastq.gz --outFileNamePrefix {} --outSAMtype BAM SortedByCoordinate" >align.sh
bash align.sh

#index the mapped .bam file

samtools index SRR1041710Aligned.sortedByCoord.out.bam

#count alignments

samtools flagstat SRR1041710_starAligned.sortedByCoord.out.bam

#remove duplicates

samtools rmdup SRR1041710Aligned.sortedByCoord.out.bam SRR1041710_nodups.bam

