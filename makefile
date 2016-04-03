concat.csv: csvs.txt
	./duh.pl csvs.txt > concat.csv

csvs.txt:
	ls *.csv|grep explorer > csvs.txt
