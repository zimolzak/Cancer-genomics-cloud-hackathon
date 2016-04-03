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
		if((ca=='prad' & ge=='kras') | (ca=='brca' & ge=='kras') | (ca=='lusc' & ge=='kras')){
			next
		}
		df = read.csv(pathname)

		Xb = data.frame(expression=df$Expression, cnv=df$CNV, isMissense=(df$Variant.Classification=='Missense_Mutation'))
		qplot(data=Xb, x=expression, y=cnv, color=isMissense)
		model=earth(isMissense ~ ., data=Xb)
		plotmo(model)
		plot(evimp(model))
		plot(model)
		print(paste(ca, ge, model$grsq)) # 0.66
	}
}

bt = read.csv("/Users/ajz/Desktop/CA Genomics Cloud/expression-cnv-variant/brca tp53 cgc_case_explorer_selected_data.csv")

