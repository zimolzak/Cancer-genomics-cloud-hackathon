basedir = "/Users/ajz/Desktop/CA Genomics Cloud/expression-cnv-variant/"

cancers = c('brca','coad','luad','lusc','prad')
genes = c('tp53', 'ttn', 'muc16', 'kras')

basefile = 'cgc_case_explorer_selected_data.csv'

for(ca in cancers)
{
	for(ge in genes)
	{
		fn = paste(ca, ge, basefile)
		print(paste(basedir, fn, sep=""))
		df = read.csv(paste(basedir, fn, sep=""))
		print(dim(df))
	}
}

bt = read.csv("/Users/ajz/Desktop/CA Genomics Cloud/expression-cnv-variant/brca tp53 cgc_case_explorer_selected_data.csv")

library(earth)

X = data.frame(expression=bt$Expression, cnv=bt$CNV, variant_class=bt$Variant.Classification)

model=earth(variant_class ~ ., data=X)
plotmo(model, nresponse=4)
plot(evimp(model))

library(ggplot2)
qplot(data=X, x=expression, y=cnv, color=variant_class)

plot(model)

