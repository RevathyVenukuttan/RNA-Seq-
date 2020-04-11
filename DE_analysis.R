library(edgeR)
library(gplots)

setwd("~/bioinfo/bioe582/1_rnaseq/")
count_table <- read.table("quant_count.txt", header=T, row.names=1)
colnames(count_table) <- c("Undiff1","Undiff2","Undiff3","DA_progenitor1","DA_progenitor2","DA_progenitor3")

group <-factor(c("Undiff","Undiff","Undiff","DA_progenitor","DA_progenitor","DA_progenitor"))

### Prepare a DGEList data type (read the edgeR documentation to learn more about it) of our data and group factors
diff <- DGEList(counts=count_table,group=group)

### Compute norm factors, and dispersion estimates (what do each of these calculations do?)
diff <- calcNormFactors(diff)
diff <- estimateCommonDisp(diff)
diff <- estimateTagwiseDisp(diff)

test <- exactTest(diff)
### NOTE: test is a data type with a lot of parts. $table has our differential statistics.

### Correct for multiple testing and add this to our stats table:
QValue <- p.adjust(test$table$PValue,method="BH")
test$table <- cbind(test$table, QValue)
### Write to tab-delimited output
write.table(test$table,"rna_seq_differential.txt",sep="\t",quote=F, col.names = NA)
### What are the columns in our output table?



normalized <- cpm(count_table)

### Write to output
write.table(normalized,"rna_seq_normalized.txt",sep="\t",quote=F, col.names = NA)

#MD plot
plotMD(test)

res <- topTags(test, n=nrow(test$table))

#number of de genes
sum(res$table$FDR < 0.05)

#extract and sort de genes
sigDownReg <- res$table[res$table$FDR<0.05,]
sigDownReg <- sigDownReg[order(sigDownReg$logFC),]
head(sigDownReg)
sigUpReg <- sigDownReg[order(sigDownReg$logFC, decreasing=TRUE),]
head(sigUpReg)

#write results in csv
write.csv(sigDownReg, file="sigDownReg.csv")
write.csv(sigUpReg, file="sigUpReg.csv")

#heat map
y <- cpm(diff, log=TRUE, prior.count = 1)
head(y)

selY <- y[rownames(res$table)[res$table$FDR<0.05],]
head(selY)

heatmap.2(selY, trace="none", main="DE genes across samples", cexRow = 0.25, cexCol = 1.0, srtCol = 45)

#design matrix
design <- model.matrix( ~0+group )
design

#contrast matrix
makeContrasts(Undiff-DA_progenitor, levels = group)



