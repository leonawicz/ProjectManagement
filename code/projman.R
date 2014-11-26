
# @knitr template_objects
# For package 'projman'

# data
rmd.header <- 
'---\ntitle: INSERT_TITLE_HERE\nauthor: Matthew Leonawicz\noutput:\n  html_document:\n    toc: true\n    theme: united\n    keep_md: true\n  ioslides_presentation:\n    widescreen: true\n    keep_md: true\n  pdf_document:\n    toc: true\n    highlight: zenburn\n---\n'

rmd.knitr.setup <-
'\n```{r knitr_setup, echo=FALSE}
opts_chunk$set(cache=FALSE, eval=FALSE, tidy=TRUE, messages=FALSE, warnings=FALSE)
read_chunk("")
```\n'

rmd.template <-
'\n
## Introduction
ADD_TEXT_HERE

### Motivation
ADD_TEXT_HERE

### Details
ADD_TEXT_HERE

#### Capabilities
ADD_TEXT_HERE

#### Limitations
ADD_TEXT_HERE

## Related items

### Files and Data
ADD_TEXT_HERE

### Code flow
ADD_TEXT_HERE

```{r code_sankey, echo=F, eval=T}
```

```{r code_sankey_embed, echo=F, eval=T, comment=NA, results="asis", tidy=F}
```

## R code

### Setup
ADD_TEXT_HERE: EXAMPLE
Setup consists of loading required **R** packages and additional files, preparing any command line arguments for use, and defining functions and other **R** objects.
\n'

# default path
matt.proj.path <- "C:/github"

# @knitr function1
newProject <- function(name, path,
	dirs=c("code", "data", "docs", "plots", "workspaces"),
	docs.dirs=c("all", "diagrams", "ioslides", "md", "notebook", "pdf", "Rmd", "timeline", "tufte"),
	overwrite=FALSE){
	
	stopifnot(is.character(name))
	name <- file.path(path, name)
	if(file.exists(name) && !overwrite) stop("This project already exists.")
	dir.create(name, recursive=TRUE, showWarnings=FALSE)
	if(!file.exists(name)) stop("Directory appears invalid.")
	
	path.dirs <- file.path(name, dirs)
	sapply(path.dirs, dir.create, showWarnings=FALSE)
	path.docs <- file.path(name, "docs", docs.dirs)
	if("docs" %in% dirs) sapply(path.docs, dir.create, showWarnings=FALSE)
	if(overwrite) cat("Project directories updated.\n") else cat("Project directories created.\n")
}

# @knitr function2
rmdHeader <- function(title="INSERT_TITLE_HERE", author="Matthew Leonawicz", theme="cosmo", highlight="zenburn", toc=TRUE, keep.md=TRUE, ioslides=FALSE, include.pdf=FALSE){
	if(toc) toc <= "true" else toc <- "false"
	if(keep.md) keep.md <= "true" else keep.md <- "false"
	if(ioslides) hdoc <- "ioslides_presentation" else hdoc <- "html_document"
	rmd.header <- paste0('---\ntitle: ', title, '\nauthor: ', author, '\noutput:\n  ', hdoc, ':\n    toc: ', toc, '\n    theme: ', theme, '\n    highlight: ', highlight, '\n    keep_md: ', keep.md, '\n')
	if(ioslides) rmd.header <- paste0(rmd.header, '    widescreen: true\n')
	if(include.pdf) rmd.header <- paste0(rmd.header, '  pdf_document:\n    toc: ', toc, '\n    highlight: ', highlight, '\n')
	rmd.header <- paste0(rmd.header, '---\n')
	rmd.header
}

# @knitr function3
genRmd <- function(path, replace=FALSE, header=rmdHeader(), update.header=FALSE, ...){
	stopifnot(is.character(path))
	files <- list.files(path, pattern=".R$", full=TRUE)
	stopifnot(length(files) > 0)
	rmd <- gsub(".R", ".Rmd", basename(files))
	rmd <- file.path(dirname(path), "docs/Rmd", rmd)
	if(!(replace | update.header)) rmd <- rmd[!sapply(rmd, file.exists)]
	if(update.header) rmd <- rmd[sapply(rmd, file.exists)]
	stopifnot(length(rmd) > 0)
	
	sinkRmd <- function(x, ...){
		y1 <- header
		y2 <- list(...)$rmd.knitr.setup
		y3 <- list(...)$rmd.template
		if(is.null(y1)) y1 <- rmd.header
		if(is.null(y2)) y2 <- rmd.knitr.setup
		if(is.null(y3)) y3 <- rmd.template
		sink(x)
		sapply(c(y1, y2, y3), cat)
		sink()
	}
	
	swapHeader <- function(x){
		l <- readLines(x)
		ind <- which(l=="---")
		l <- l[(ind[2] + 1):length(l)]
		l <- paste0(l, "\n")
		sink(x)
		sapply(c(header, l), cat)
		sink()
	}
	
	if(update.header){
		sapply(rmd, swapHeader, ...)
		cat("yaml header updated for each .Rmd file.\n")
	} else {
		sapply(rmd, sinkRmd, ...)
		cat(".Rmd files created for each .R file.\n")
	}
}

# @knitr function4
chunkNames <- function(path, rChunkID="# @knitr", rmdChunkID="```{r", append.new=FALSE){
	files <- list.files(path, pattern=".R$", full=TRUE)
	stopifnot(length(files) > 0)
	l1 <- lapply(files, readLines)
	l1 <- rapply(l1, function(x) x[substr(x, 1, nchar(rChunkID))==rChunkID], how="replace")
	l1 <- rapply(l1, function(x, p) gsub(paste0(p, " "), "", x), how="replace", p=rChunkID)
	if(!append.new) return(l1)
	
	appendRmd <- function(x, rmd.files, rChunks, rmdChunks, ID){
		r1 <- rmdChunks[[x]]
		r2 <- rChunks[[x]]
		r.new <- r2[!(r2 %in% r1)]
		if(length(r.new)){
			r.new <- paste0(ID, " ", r.new, "}\n```\n", collapse="") # Hard coded brace and backticks
			sink(rmd.files[x], append=TRUE)
			cat("\nNEW_CODE_CHUNKS\n")
			cat(r.new)
			sink()
			paste(basename(rmd.files[x]), "appended with new chunk names from .R file")
		}
		else paste("No new chunk names appended to", basename(rmd.files[x]))
	}
	
	rmd <- gsub(".R", ".Rmd", basename(files))
	rmd <- file.path(dirname(path), "docs/Rmd", rmd)
	rmd <- rmd[sapply(rmd, file.exists)]
	stopifnot(length(rmd) > 0) # Rmd files must exist
	files.ind <- match(gsub(".Rmd", "", basename(rmd)), gsub(".R", "", basename(files))) # Rmd exist for which R script
	l2 <- lapply(rmd, readLines)
	l2 <- rapply(l2, function(x) x[substr(x, 1, nchar(rmdChunkID))==rmdChunkID], how="replace")
	l2 <- rapply(l2, function(x, p) gsub(paste0(p, " "), "", x), how="replace", p=gsub("\\{", "\\\\{", rmdChunkID))
	l2 <- rapply(l2, function(x) gsub("}", "", sapply(strsplit(x, ","), "[[", 1)), how="replace")
	sapply(1:length(rmd), appendRmd, rmd.files=rmd, rChunks=l1[files.ind], rmdChunks=l2, ID=rmdChunkID)
}


# @knitr testing
proj.name <- "TEST_PROJECT" #"ProjectManagement"
proj.location <- matt.proj.path

newProject(proj.name, proj.location, overwrite=T)

genRmd(path=file.path(matt.proj.path, proj.name, "code"), header=rmdHeader(), update.header=T)

chunkNames(path=file.path(matt.proj.path, proj.name, "code"), append.new=TRUE)
