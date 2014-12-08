# @knitr setup
library(rmarkdown)
library(knitr)

setwd("C:/github/ProjectManagement/docs/Rmd")

# R scripts
files.r <- list.files("../../code", pattern=".R$", full=T)
#files.r <- files.r[basename(files.r)!="drg.R"]
files.Rmd <- list.files(pattern=".Rmd$", full=T)

# potential non-Rmd directories for writing various output files
outtype <- file.path(dirname(getwd()), list.dirs("../", full=F, recursive=F))
outtype <- outtype[basename(outtype)!="Rmd"]

# @knitr save
# write all yaml front-matter-specified outputs to Rmd directory for all Rmd files
lapply(files.Rmd, render, output_format="all")

# write all specific outputs to specific directories for all Rmd files
#lapply(files.Rmd, render, output_format=html_document(), output_dir=outtype[basename(outtype)=="all"])
#lapply(files.Rmd, render, output_format=md_document(), output_dir=outtype[basename(outtype)=="all"])
lapply(files.Rmd, render, output_format="pdf_document", output_dir=outtype[basename(outtype)=="pdf"], intermediates_dir=outtype[basename(outtype)=="pdf"])


