#### The generates documentation in various formats for other code ####
library(rmarkdown)
library(knitr)

setwd("C:/github/ProjectManagement/docs/Rmd")
files.r <- list.files("../../code", pattern=".R$", full=T)
files.r <- files.r[basename(files.r)!="drg.R"]
files.Rmd <- list.files(full=T)
outtype <- file.path(dirname(getwd()), list.dirs("../", full=F, recursive=F))
outtype <- outtype[basename(outtype)!="Rmd"]
#lapply(files.r, render, output_dir=outtype[basename(outtype)=="notebook"], intermediates_dir=outtype[basename(outtype)=="notebook"])
#lapply(files.r, render, output_format="pdf_document", output_dir=outtype[basename(outtype)=="notebook"], intermediates_dir=outtype[basename(outtype)=="notebook"])

# testing
#lapply(files.Rmd, render, output_format="all", output_dir=outtype[basename(outtype)=="all"])
lapply(files.Rmd, render, output_format=html_document(), output_dir=outtype[basename(outtype)=="all"])
lapply(files.Rmd, render, output_format=md_document(), output_dir=outtype[basename(outtype)=="all"])
#lapply(files.Rmd, render, output_format="pdf_document", output_dir=outtype[basename(outtype)=="pdf"], intermediates_dir=outtype[basename(outtype)=="pdf"])


