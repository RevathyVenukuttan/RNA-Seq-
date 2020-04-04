#To index the genome to the reference genome which is hg19 from human chr22 using STAR
#command line operation

cd ~/bioinfo/bioe582/1_rnaseq/hg19_chr22_ref
STAR --runMode genomeGenerate --genomeDir ./ --genomeFastaFiles hg19_chr22.fa --sjdbGTFfile hg19_chr22.gtf
