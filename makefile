results: concat.csv
	./stratified_classifier.R concat.csv disease gene Variant.Classification Missense_Mutation Expression CNV
	./epidemiology.R

concat.csv: csvs.txt
	./duh.pl csvs.txt > concat.csv

csvs.txt:
	ls *.csv|grep explorer > csvs.txt
