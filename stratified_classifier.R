#!/usr/bin/env Rscript
# usage (incomplete): ./stratified_classifier.R concat.csv disease gene Variant.Classification Missense_Mutation Expression CNV
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

for(ca in cancers)
{
	for(ge in genes)
	{
		df = input_df[cancer_column == ca & gene_column == ge,]
		code_text = paste("df$", binarize_me, sep='')
		column_to_binarize = eval(parse(text=code_text))
		code_text = paste("df$", x1, sep='')
		x1_column = eval(parse(text=code_text))
		code_text = paste("df$", x2, sep='')
		x2_column = eval(parse(text=code_text))
		
		# have to figure out how many classes in our subset, collapse levels
		Xb = data.frame(expression=x1_column, cnv=x2_column, isMissense=(column_to_binarize == binarize_val))
		classes = table(Xb$isMissense)
		
		if(dim(classes) < 2 | min(classes) < 10) ## FIXME - too conservative??
		{
			# skip to next stratum if only 1 class or if very few TRUEs or FALSES.
			# because we can't model and/or do 10 fold cross validation.
			print(paste("too few variant classes", ca, ge))
			next
		}
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
ggsave(p, file=paste(basedir, "all_rsq.png", sep='')) ## FIXME
