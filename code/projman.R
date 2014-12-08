
# @knitr template_objects
# For package 'projman'

# data
rmd.knitr.setup <-
'\n```{r knitr_setup, echo=FALSE}
opts_chunk$set(cache=FALSE, eval=FALSE, tidy=TRUE, message=FALSE, warning=FALSE)
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
	docs.dirs=c("diagrams", "ioslides", "notebook", "pdf", "Rmd/include", "timeline", "tufte"),
	overwrite=FALSE){
	
	stopifnot(is.character(name))
	name <- file.path(path, name)
	if(file.exists(name) && !overwrite) stop("This project already exists.")
	dir.create(name, recursive=TRUE, showWarnings=FALSE)
	if(!file.exists(name)) stop("Directory appears invalid.")
	
	path.dirs <- file.path(name, dirs)
	sapply(path.dirs, dir.create, showWarnings=FALSE)
	path.docs <- file.path(name, "docs", docs.dirs)
	if("docs" %in% dirs) sapply(path.docs, dir.create, recursive=TRUE, showWarnings=FALSE)
	if(overwrite) cat("Project directories updated.\n") else cat("Project directories created.\n")
}

# @knitr function2
rmdHeader <- function(title="INSERT_TITLE_HERE", author="Matthew Leonawicz", theme="united", highlight="zenburn", toc=TRUE, keep.md=TRUE, ioslides=FALSE, include.pdf=FALSE){
	if(toc) toc <- "true" else toc <- "false"
	if(keep.md) keep.md <- "true" else keep.md <- "false"
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

# @knitr function5
genNavbar <- function(htmlfile="navbar.html", title, menu, submenus, files, title.url="/", home.url="/", site.url="", site.name="Github"){

	fillSubmenu <- function(x, name, file){
		if(file[x]=="divider") return('              <li class="divider"></li>\n')
		if(file[x]=="header") return(paste0('              <li class="nav-header">', name[x], '</li>\n'))
		paste0('              <li><a href="', file[x], '">', name[x], '</a></li>\n')
	}
	
	fillMenu <- function(x, menu, submenus, files){
		paste0(
		'<li class="dropdown">\n            <a href="', 
			gsub(" ", "-", tolower(menu[x])), 
			'" class="dropdown-toggle" data-toggle="dropdown">', menu[x], 
			' <b class="caret"></b></a>\n            <ul class="dropdown-menu">\n',
			paste(sapply(1:length(submenus[[x]]), fillSubmenu, name=submenus[[x]], file=files[[x]]), sep="", collapse=""),
			'            </ul>\n', collapse="")
	}
	
	x <- paste0(
		'<div class="navbar navbar-default navbar-fixed-top">\n  <div class="navbar-inner">\n    <div class="container">\n      <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">\n        <span class="icon-bar"></span>\n        <span class="icon-bar"></span>\n        <span class="icon-bar"></span>\n      </button>\n      <a class="brand" href="', title.url, '">', title, '</a>\n      <div class="nav-collapse collapse">\n        <ul class="nav">\n          <li><a href="', home.url, '">Home</a></li>\n          ',
		paste(sapply(1:length(menu), fillMenu, menu=menu, submenus=submenus, files=files), sep="", collapse="\n          "),
		'        </ul>\n        <ul class="nav pull-right">\n          <a class="btn btn-primary" href="', site.url, '">\n            <i class="fa fa-github fa-lg"></i>\n            ',site.name,'\n          </a>\n        </ul>\n      </div><!--/.nav-collapse -->\n    </div>\n  </div>\n</div>\n',
		collpase="")
	sink(htmlfile)
	cat(x)
	sink()
	x
}

# @knitr function6
genOutyaml <- function(file, theme="cosmo", highlight="zenburn", lib=NULL, header=NULL, before_body=NULL, after_body=NULL){
	output.yaml <- paste0('html_document:\n  self_contained: false\n  theme: ', theme, '\n  highlight: ', highlight, '\n  mathjax: null\n  toc_depth: 2\n')
	if(!is.null(lib)) output.yaml <- paste0(output.yaml, '  lib_dir: ', lib, '\n')
	output.yaml <- paste0(output.yaml, '  includes:\n')
	if(!is.null(header)) output.yaml <- paste0(output.yaml, '    in_header: include/', header, '\n')
	if(!is.null(before_body)) output.yaml <- paste0(output.yaml, '    before_body: include/', before_body, '\n')
	if(!is.null(after_body)) output.yaml <- paste0(output.yaml, '    after_body: include/', after_body, '\n')
	sink(file)
	cat(output.yaml)
	sink()
	output.yaml
}
