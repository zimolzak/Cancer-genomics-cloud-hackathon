library(earth)
library(ggplot2)

basedir = "/Users/ajz/Desktop/CA Genomics Cloud/expression-cnv-variant/"
cancers = c('brca','coad','luad','lusc','prad')
genes = c('tp53', 'ttn', 'muc16', 'kras')
basefile = 'cgc_case_explorer_selected_data.csv'
grsq_vals = data.frame()
make_many_plots = FALSE

for(ca in cancers)
{
	for(ge in genes)
	{
		filename = paste(ca, ge, basefile)
		pathname = paste(basedir, filename, sep="")
		if(ca=='prad' & ge=='kras')
		{
			# do not attempt to open. I have prior knowledge this file doesn't exist. Less adhoc later.
			next
		}
		df = read.csv(pathname)
		if(dim(table(df$Variant.Classification)) == 1)
		{
			# it has only one class so skip trying to model this stratum
			next
		}
		Xb = data.frame(expression=df$Expression, cnv=df$CNV, isMissense=(df$Variant.Classification=='Missense_Mutation'))
		model=earth(isMissense ~ ., data=Xb)
		if(make_many_plots)
		{
			qplot(data=Xb, x=expression, y=cnv, color=isMissense)
			plotmo(model)
			plot(evimp(model))
			plot(model)
		}
		grsq_vals = rbind(grsq_vals, data.frame(disease=ca, gene=ge, grsq=model$grsq))
	}
}

print(grsq_vals)
ggplot(grsq_vals, aes(disease, gene)) + geom_raster(aes(fill = grsq))
