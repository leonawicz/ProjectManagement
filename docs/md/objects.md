


### Template objects

Character string objects are defined which are used to fill templates when generating new files for a project.
A tentative default path is also included since this code relates to my own work.
Realistically, any objects current shown here will most likely eventually be incorporated into package functions in some form.
I prefer not to have many straggler objects floating around.


```r
# For package 'rpm'

# data

rmd.template <- "\n\n## Introduction\nADD_TEXT_HERE\n\n### Motivation\nADD_TEXT_HERE\n\n### Details\nADD_TEXT_HERE\n\n#### Capabilities\nADD_TEXT_HERE\n\n#### Limitations\nADD_TEXT_HERE\n\n## Related items\n\n### Files and Data\nADD_TEXT_HERE\n\n### Code flow\nADD_TEXT_HERE\n\n```{r code_sankey, echo=F, eval=T}\n```\n\n```{r code_sankey_embed, echo=F, eval=T, comment=NA, results=\"asis\", tidy=F}\n```\n\n## R code\n\n### Setup\nADD_TEXT_HERE: EXAMPLE\nSetup consists of loading required **R** packages and additional files, preparing any command line arguments for use, and defining functions and other **R** objects.\n\n"

# default path
matt.proj.path <- "C:/github"
```
