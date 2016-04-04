Cancer-genomics-cloud-hackathon
========

Prediction of mutation type in TCGA. Compare TCGA NSCLC mutated genes
to my data.

Predicting mutation type
--------

What gene:cancer-type pairs have easily predicted mutation type?
(Predicting based on gene expression and copy number variation.)

![heatmap](https://dl.dropboxusercontent.com/u/38640281/github_img/all_rsq.png)

Comparing mutations in 2 populations
--------

Gene | VA mutations | TCGA mutations | VA Percent | TCGA Percent | P       | Significant at α=0.0056?
-----|--------------|----------------|------------|--------------|---------|----------
TP53 | 32/40       | 251/1005        | 80         | 25           |<0.00001 | TRUE
CDKN2A | 8/40       | 37/997         | 20         | 3.7          | 0.00018 | TRUE
KRAS | 9/40       | 70/979           | 22.5       | 7.2          | 0.00242 | TRUE
FGFR1 | 3/40       | 5/910           | 7.5        | 0.5          | 0.00335 | TRUE
MET | 4/40       | 25/997            | 10         | 2.5          | 0.02244 | FALSE
PTEN | 3/40       | 17/950           | 7.5        | 1.8          | 0.04323 | FALSE
RB1 | 3/40       | 22/971            | 7.5        | 2.3          | 0.07218 | FALSE
ATM | 3/40       | 31/1007           | 7.5        | 3.1          | 0.13658 | FALSE
EGFR | 3/40       | 41/992           | 7.5        | 4.1          | 0.2406  | FALSE
