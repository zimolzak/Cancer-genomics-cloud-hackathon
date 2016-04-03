epi = read.csv("~/Desktop/CA Genomics Cloud/expression-cnv-variant/epidemiology.csv")
epi = cbind(epi, cases_negative=(epi$total_cases - epi$n_cases_mutated))

genes = levels(epi$gene)
pops = levels(epi$population)

alpha = 0.05
alpha_prime = alpha / length(genes)

report = data.frame()

for(g in genes)
{
	tcga_pos = as.numeric(epi$n_cases_mutated[epi$gene == g & epi$population == 'tcga'])
	tcga_neg = as.numeric(epi$cases_negative[epi$gene == g & epi$population == 'tcga'])
	va_pos = as.numeric(epi$n_cases_mutated[epi$gene == g & epi$population == 'va'])
	va_neg = as.numeric(epi$cases_negative[epi$gene == g & epi$population == 'va'])
	tcga_total = tcga_pos + tcga_neg
	va_total = va_pos + va_neg

	TCGA_Rate = tcga_pos / tcga_total
	VA_Rate = va_pos / va_total

	T = matrix(
		c(tcga_pos, tcga_neg, va_pos, va_neg),
		nrow=2,
		dimnames=list(c('n_cases_mutated', 'cases_negative'), pops)
	)
	#writeLines(g)
	#print(T)
	#writeLines("\n")
	P = fisher.test(T)$p.value
	Significant = (P < alpha_prime)
	report = rbind(report, data.frame(Gene=toupper(g), VA_mutations=paste(va_pos, va_total, sep='/'), TCGA_mutations=paste(tcga_pos, tcga_total, sep='/'), VA_Percent=(VA_Rate*100), TCGA_Percent=round(TCGA_Rate*100, 1), P=round(P, 5), Significant))
}

#print(report[order(report$P), ])
write.csv(report[order(report$P), ], file="/Users/ajz/Desktop/CA Genomics Cloud/expression-cnv-variant/epi_compare_report.csv")
