library(earth)
library(ggplot2)

basedir = "/Users/ajz/Desktop/CA Genomics Cloud/expression-cnv-variant/"
cancers = c('brca','coad','luad','lusc','prad')
genes = c('tp53', 'ttn', 'muc16', 'kras')
basefile = 'cgc_case_explorer_selected_data.csv'
grsq_vals = data.frame()

for(ca in cancers)
{
	for(ge in genes)
	{
		filename = paste(ca, ge, basefile)
		pathname = paste(basedir, filename, sep="")
		df = read.csv(pathname)
		print(dim(df))
	}
}

bt = read.csv("/Users/ajz/Desktop/CA Genomics Cloud/expression-cnv-variant/brca tp53 cgc_case_explorer_selected_data.csv")

X = data.frame(expression=bt$Expression, cnv=bt$CNV, variant_class=bt$Variant.Classification)
qplot(data=X, x=expression, y=cnv, color=variant_class)
model=earth(variant_class ~ ., data=X)
plotmo(model, nresponse=4)
plot(evimp(model))
plot(model, nresponse=4)
model$grsq # 0.35

Xb = data.frame(expression=bt$Expression, cnv=bt$CNV, isMissense=(bt$Variant.Classification=='Missense_Mutation'))
qplot(data=Xb, x=expression, y=cnv, color=isMissense)
model=earth(isMissense ~ ., data=Xb)
plotmo(model)
plot(evimp(model))
plot(model)
model$grsq # 0.66
