library(earth)
library(ggplot2)

basedir = "/Users/ajz/Desktop/CA Genomics Cloud/expression-cnv-variant/"
cancers = c('brca','coad','luad','lusc','prad')
genes = c('tp53', 'ttn', 'muc16', 'kras')
basefile = 'cgc_case_explorer_selected_data.csv'
grsq_vals = data.frame()
make_many_plots = TRUE

for(ca in cancers)
{
	for(ge in genes)
	{
		filename = paste(ca, ge, basefile)
		pathname = paste(basedir, filename, sep="")
		if(!file.exists(pathname))
		{
			print(paste("No file for", ca, ge))
			next
		}
		df = read.csv(pathname)
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
