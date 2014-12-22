# Project Management
Matthew Leonawicz  



## Dynamic report generation
The script, `drg.R`, is used to compile reports in various formats based on project **R** and/or Rmd files.
Using this project management project as an example, markdown and html files are generated for existing Rmd files.
This is not clear from the code below because `output_format="all"` is ambiguous.
In the yaml front-matter of each Rmd file for this project, the file type `html_document:` and specific flag `keep_md: true` are specified.

No other output files are specified such as pdf.
To make pdf files for example, they would be specified directly in this script or the Rmd front-matter would have to be updated to include them.
I prefer to keep them separate because I rarely want to generate pdf files from most Rmd files and when I do I will want them written to another location.

## R code

### Initial setup


```r
library(rmarkdown)
library(knitr)

setwd("C:/github/ProjectManagement/docs/Rmd")

# R scripts
files.r <- list.files("../../code", pattern = ".R$", full = T)
# files.r <- files.r[basename(files.r)!='drg.R']
files.Rmd <- list.files(pattern = ".Rmd$", full = T)

# potential non-Rmd directories for writing various output files
outtype <- file.path(dirname(getwd()), list.dirs("../", full = F, recursive = F))
outtype <- outtype[basename(outtype) != "Rmd"]
```

### Render documents


```r
# write all yaml front-matter-specified outputs to Rmd directory for all Rmd
# files
lapply(files.Rmd, render, output_format = "all")

# write all specific outputs to specific directories for all Rmd files
# lapply(files.Rmd, render, output_format=html_document(),
# output_dir=outtype[basename(outtype)=='all']) lapply(files.Rmd, render,
# output_format=md_document(), output_dir=outtype[basename(outtype)=='all'])
lapply(files.Rmd, render, output_format = "pdf_document", output_dir = outtype[basename(outtype) == 
    "pdf"], intermediates_dir = outtype[basename(outtype) == "pdf"])
```
