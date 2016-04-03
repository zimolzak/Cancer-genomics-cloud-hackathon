#!/usr/bin/env Rscript
# usage (incomplete): ./stratified_classifier.R concat.csv disease gene Variant.Classification
library(earth)
library(ggplot2)

args = commandArgs(trailingOnly = TRUE)
csvfilename = args[1]
stratify1 = args[2]
stratify2 = args[3]
binarize_me = args[4]
binarize_val = args[5]
x1 = args[6]
x2 = args[7]

grsq_vals = data.frame()
make_many_plots = FALSE
input_df = read.csv(csvfilename)

code_text = paste("input_df$", stratify1, sep='')
cancer_column = eval(parse(text=code_text))
cancers = levels(cancer_column)

code_text = paste("input_df$", stratify2, sep='')
gene_column = eval(parse(text=code_text))
genes = levels(gene_column)

print(genes)
print(cancers)
q()


for(ca in cancers)
{
	for(ge in genes)
	{
		df = input_df[cancer_column == ca & gene_column = ge,]
		code_text = paste("df$", binarize_me, sep='')
		column_to_binarize = eval(parse(text=code_text))
		if(dim(table(df$Variant.Classification)) < 3 ) # 3 because luad*kras has only 2 classes, no good for nfold
		{
			# FIXME - really we should look *inside* table(df$...)
			# because 2 classes is ok, but 1 class w/ 1 member (unbalanced) is not ok.
			print(paste("too few variant classes", ca, ge))
			next
		}
		Xb = data.frame(expression=df$Expression, cnv=df$CNV, isMissense=(df$Variant.Classification=='Missense_Mutation'))
		print(paste("modeling", ca, ge))
		model=earth(isMissense ~ ., data=Xb, nfold=10, degree=2)
		if(make_many_plots)
		{
			plot_prefix = paste(basedir, paste(ca, ge), sep='') # "like /a/b/c/prad kras"
			
			Q = qplot(data=Xb, x=expression, y=cnv, color=isMissense)
			ggsave(Q, file=paste(plot_prefix, 'scatter.png'))
			
			png(paste(plot_prefix, 'plotmo.png'))
			plotmo(model)
			dev.off()
						
			png(paste(plot_prefix, 'model.png'))
			plot(model)
			dev.off()
		}
		grsq_vals = rbind(grsq_vals, data.frame(Disease=toupper(ca), Gene=toupper(ge), GRSq=model$grsq))
	}
}

print(grsq_vals)
p = ggplot(grsq_vals, aes(Disease, Gene)) + geom_raster(aes(fill = GRSq))
ggsave(p, file=paste(basedir, "all_rsq.png", sep=''))
