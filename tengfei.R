source("http://bioconductor.org/biocLite.R")
#useDevel(devel = TRUE)
#biocLite("sevenbridges")

library(devtools)
install_github("tengfei/sevenbridges", build_vignettes=TRUE, 
  repos=BiocInstaller::biocinstallRepos(),
  dependencies=TRUE)
