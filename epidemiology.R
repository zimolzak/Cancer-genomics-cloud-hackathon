epi = read.csv("~/Desktop/CA Genomics Cloud/expression-cnv-variant/epidemiology.csv")
epi = cbind(epi, cases_negative=(epi$total_cases - epi$n_cases_mutated))

genes = levels(epi$gene)
pops = levels(epi$population)

alpha = 0.05
alpha_prime = alpha / length(genes)

report = data.frame()

for(g in genes)
{
	T = matrix(
		c(
			as.numeric(epi[epi$gene == g & epi$population == pops[1], c('n_cases_mutated', 'cases_negative')]),
			as.numeric(epi[epi$gene == g & epi$population == pops[2], c('n_cases_mutated', 'cases_negative')])
		),
		nrow=2,
		dimnames=list(c('n_cases_mutated', 'cases_negative'), pops)
	)
	writeLines(c(g, '========'))
	print(T)
	writeLines(paste('P = ', fisher.test(T)$p.value))
	writeLines(paste(g, 'is significant?', fisher.test(T)$p.value < alpha_prime))
	writeLines('\n')
}
