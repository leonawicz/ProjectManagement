
# @knitr template_objects
# For package 'projman'

# data

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

# @knitr fun_newProject
newProject <- function(name, path,
	dirs=c("code", "data", "docs", "plots", "workspaces"),
	docs.dirs=c("diagrams", "ioslides", "notebook", "Rmd/include", "md", "html", "Rnw", "pdf", "timeline", "tufte"),
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

# @knitr fun_rmdHeader
rmdHeader <- function(title="INSERT_TITLE_HERE", author="Matthew Leonawicz", theme="united", highlight="zenburn", toc=TRUE, keep.md=TRUE, ioslides=FALSE, include.pdf=FALSE){
	if(toc) toc <- "true" else toc <- "false"
	if(keep.md) keep.md <- "true" else keep.md <- "false"
	if(ioslides) hdoc <- "ioslides_presentation" else hdoc <- "html_document"
	rmd.header <- "---\n"
	if(!is.null(title)) rmd.header <- paste0(rmd.header, 'title: ', title, '\n')
	if(!is.null(author)) rmd.header <- paste0(rmd.header, 'author: ', author, '\n')
	rmd.header <- paste0(rmd.header, 'output:\n  ', hdoc, ':\n    toc: ', toc, '\n    theme: ', theme, '\n    highlight: ', highlight, '\n    keep_md: ', keep.md, '\n')
	if(ioslides) rmd.header <- paste0(rmd.header, '    widescreen: true\n')
	if(include.pdf) rmd.header <- paste0(rmd.header, '  pdf_document:\n    toc: ', toc, '\n    highlight: ', highlight, '\n')
	rmd.header <- paste0(rmd.header, '---\n')
	rmd.header
}

# @knitr fun_rmdknitrSetup
rmdknitrSetup <- function(file, include.sankey=TRUE){
	x <- paste0('\n```{r knitr_setup, echo=FALSE}\nopts_chunk$set(cache=FALSE, eval=FALSE, tidy=TRUE, message=FALSE, warning=FALSE)\n')
	if(include.sankey) x <- paste0(x, 'read_chunk("../../code/proj_sankey.R")\n')
	x <- paste0(x, 'read_chunk("../../code/', file, '")\n```\n')
	x
}

# @knitr fun_genRmd
genRmd <- function(path, replace=FALSE, header=rmdHeader(), knitrSetupChunk=rmdknitrSetup(), update.header=FALSE, ...){
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
		y2 <- kniterSetupChunk
		y3 <- list(...)$rmd.template
		if(is.null(y1)) y1 <- rmd.header
		if(is.null(y2)) y2 <- rmd.knitr.setup(gsub(".Rmd", ".R", basename(x)))
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

# @knitr fun_chunkNames
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

# @knitr fun_convertDocs
convertDocs <- function(path, rmdChunkID=c("```{r", "}", "```"), rnwChunkID=c("<<", ">>=", "@"), doc.title=NULL, doc.author=NULL, emphasis="replace", overwrite=FALSE, ...){
	stopifnot(is.character(path))
	type <- basename(path)
	rmd.files <- list.files(path, pattern=".Rmd$", full=TRUE)
	rnw.files <- list.files(path, pattern=".Rnw$", full=TRUE)
	dots <- list(...)
	if(rmdChunkID[1]=="```{r") rmdChunkID[1] <- paste0(rmdChunkID[1], " ")
	gsbraces <- function(txt) gsub("\\{", "\\\\{", txt)
	if(type=="Rmd"){
		stopifnot(length(rmd.files) > 0)
		outDir <- file.path(dirname(path), "Rnw")
		if(is.null(doc.class <- dots$doc.class)) doc.class <- "article"
		if(is.null(doc.packages <- dots$doc.packages)) doc.packages <- "geometry"
		doc.class.string <- paste0("\\documentclass{", doc.class, "}")
		doc.packages.string <- paste0(sapply(doc.packages, function(x) paste0("\\usepackage{", x, "}")), collapse="\n")
		if("geometry" %in% doc.packages) doc.packages.string <- c(doc.packages.string, "\\geometry{verbose, tmargin=2.5cm, bmargin=2.5cm, lmargin=2.5cm, rmargin=2.5cm}")
		header.rnw <- c(doc.class.string, doc.packages.string, "\\begin{document}\n")
	} else if(type=="Rnw") {
		stopifnot(length(rnw.files) > 0)
		outDir <- file.path(dirname(path), "Rmd")
	} else stop("path must end in 'Rmd' or 'Rnw'.")
	
	swapHeadings <- function(from, to, x){
		nc <- nchar(x)
		ind <- which(substr(x, 1, 8)=="\\section" | substr(x, 1, 4)=="\\sub")
		if(!length(ind)){ # assume Rmd file
			ind <- which(substr(x, 1, 1)=="#")
			ind.n <- rep(1, length(ind))
			for(i in 2:6){
				ind.tmp <- which(substr(x[ind], 1, i)==substr("######", 1, i))
				if(length(ind.tmp)) ind.n[ind.tmp] <- ind.n[ind.tmp] + 1 else break
			}
			for(i in 1:length(ind)){
				n <- ind.n[i]
				input <- paste0(substr("######", 1, n), " ")
				h <- x[ind[i]]
				h <- gsub("\\*", "_", h) # Switch any markdown boldface asterisks in headings to double underscores
				heading <- gsub("\n", "", substr(h, n+2, nc[ind[i]]))
				#h <- gsub(input, "", h)
				if(n <= 2) subs <- "\\" else if(n==3) subs <- "\\sub" else if(n==4) subs <- "\\subsub" else if(n >=5) subs <- "\\subsubsub"
				output <- paste0("\\", subs, "section{", heading, "}\n")
				x[ind[i]] <- gsub(h, output, h)
			}
		} else { # assume Rnw file
			ind <- which(substr(x, 1, 8)=="\\section")
			if(length(ind)){
				for(i in 1:length(ind)){
					h <- x[ind[i]]
					heading <- paste0("## ", substr(h, 10, nchar(h)-2))
					x[ind[i]] <- gsub(gsbraces(h), heading, h)
				}
			}
			ind <- which(substr(x, 1, 4)=="\\sub")
			if(length(ind)){
				for(i in 1:length(ind)){
					h <- x[ind[i]]
					z <- substr(h, 2, 10)
					if(z=="subsubsub") {p <- "##### "; n <- 18 } else if(substr(z, 1, 6)=="subsub") { p <- "#### "; n <- 15 } else if(substr(z, 1, 3)=="sub") { p <- "### "; n <- 12 }
					heading <- paste0(p, substr(h, n, nchar(h)-2))
					x[ind[i]] <- gsub(gsbraces(h), heading, h)
				}
			}
		}
		x
	}
	
	swapChunks <- function(from, to, x){
		nc <- nchar(x)
		chunk.start.open <- substr(x, 1, nchar(from[1]))==from[1]
		chunk.start.close <- substr(x, nc-1-nchar(from[2])+1, nc-1)==from[2]
		chunk.start <- which(chunk.start.open & chunk.start.close)
		chunk.end <- which(substr(x, 1, nchar(from[3]))==from[3] & nc==nchar(from[3])+1)
		x[chunk.start] <- gsub(from[2], to[2], gsub(gsbraces(from[1]), gsbraces(to[1]), x[chunk.start]))
		x[chunk.end] <- gsub(from[3], to[3], x[chunk.end])
		chunklines <- as.numeric(unlist(mapply(seq, chunk.start, chunk.end)))
		list(x, chunklines)
	}
	
	# I know I use '**' strictly for bold font in Rmd files.
	# For now, this function assumes:
	# 1. The only emphasis in a doc is boldface or typewriter.
	# 2. These instances are always preceded by a space, a carriage return, or an open bracket,
	# 3. and followed by a space, period, comma, or closing bracket.
	swapEmphasis <- function(x, emphasis="remove",
		pat.remove=c("`", "\\*\\*", "__"),
		pat.replace=pat.remove,
		replacement=c("\\\\texttt\\{", "\\\\textbf\\{", "\\\\textbf\\{", "\\}", "\\}", "\\}")){
		
		stopifnot(emphasis %in% c("remove", "replace"))
		n <- length(pat.replace)
		rep1 <- replacement[1:n]
		rep2 <- replacement[(n+1):(2*n)]
		prefix <- c(" ", "^", "\\{", "\\(")
		suffix <- c(" ", ",", "-", "\n", "\\.", "\\}", "\\)")
		n.p <- length(prefix)
		n.s <- length(suffix)
		pat.replace <- c(paste0(rep(prefix, n), rep(pat.replace, each=n.p)), paste0(rep(pat.replace, each=n.s), rep(suffix, n)))
		replacement <- c(paste0(rep(gsub("\\^", "", prefix), n), rep(rep1, each=n.p)), paste0(rep(rep2, each=n.s), rep(suffix, n)))
		if(emphasis=="remove") for(k in 1:length(pat.remove)) x <- sapply(x, function(v, p, r) gsub(p, r, v), p=pat.remove[k], r="")
		if(emphasis=="replace") for(k in 1:length(pat.replace)) x <- sapply(x, function(v, p, r) gsub(p, r, v), p=pat.replace[k], r=replacement[k])
		x
	}
	
	swap <- function(file, header=NULL, outDir, ...){
		ext <- tail(strsplit(file, "\\.")[[1]], 1)
		l <- readLines(file)
		l <- l[substr(l, 1, 7)!="<style>"] # Strip any html style lines
		if(ext=="Rmd"){
			out.ext <- "Rnw"
			h.ind <- 1:which(l=="---")[2]
			h <- l[h.ind]
			t.ind <- which(substr(h, 1, 7)=="title: ")
			a.ind <- which(substr(h, 1, 8)=="author: ")
			if(is.null(doc.title) & length(t.ind)) doc.title <- substr(h[t.ind], 8, nchar(h[t.ind]))
			if(is.null(doc.author) & length(a.ind)) doc.author <- substr(h[a.ind], 9, nchar(h[a.ind]))
			if(!is.null(doc.title)) header <- c(header, paste0("\\title{", doc.title, "}"))
			if(!is.null(doc.author)) header <- c(header, paste0("\\author{", doc.author, "}"))
			if(!is.null(doc.title)) header <- c(header, "\\maketitle\n")
		} else if(ext=="Rnw") {
			out.ext <- "Rmd"
			begin.doc <- which(l=="\\begin{document}")
			make.title <- which(l=="\\maketitle")
			if(length(make.title)) h.ind <- 1:make.title else h.ind <- 1:begin.doc
			h <- l[h.ind]
			t.ind <- which(substr(h, 1, 6)=="\\title")
			a.ind <- which(substr(h, 1, 7)=="\\author")
			if(is.null(doc.title) & length(t.ind)) doc.title <- substr(h[t.ind], 8, nchar(h[t.ind])-1)
			if(is.null(doc.author) & length(a.ind)) doc.author <- substr(h[a.ind], 9, nchar(h[a.ind])-1)
			header <- rmdHeader(title=doc.title, author=doc.author)
		}
		header <- paste0(header, collapse="\n")
		l <- paste0(l[-h.ind], "\n")
		if(ext=="Rmd") { from <- rmdChunkID; to <- rnwChunkID}
		if(ext=="Rnw") { from <- rnwChunkID; to <- rmdChunkID}
		l <- swapHeadings(from=from, to=to, x=l)
		chunks <- swapChunks(from=from, to=to, x=l)
		l <- chunks[[1]]
		if(ext=="Rmd") l[-chunks[[2]]] <- sapply(l[-chunks[[2]]], function(v, p, r) gsub(p, r, v), p="_", r="\\\\_")
		if(ext=="Rmd") l <- swapEmphasis(x=l, emphasis=emphasis)
		l <- c(header, l, "\n\\end{document}\n")
		outfile <- file.path(outDir, gsub(paste0("\\.", ext), paste0("\\.", out.ext), basename(file)))
		if(overwrite || !file.exists(outfile)){
			sink(outfile)
			sapply(l, cat)
			sink()
			print(paste("Writing", outfile))
		}
	}
	
	if(type=="Rmd"){
		sapply(rmd.files, swap, header=header.rnw, outDir=outDir, ...)
		cat(".Rmd to .Rnw file conversion complete.\n")
	} else {
		sapply(rnw.files, swap, header=NULL, outDir=outDir, ...)
		cat(".Rnw to .Rmd file conversion complete.\n")
	}
}

# @knitr fun_moveDocs
moveDocs <- function(path.docs, type=c("md", "html","pdf"), move=TRUE, copy=FALSE, remove.latex=TRUE, latexDir="LaTeX"){
	if(any(!(type %in% c("md", "html","pdf")))) stop("type must be among 'md', 'html', and 'pdf'")
	stopifnot(move | copy)
	if(path.docs=="." | path.docs=="./") path.docs <- getwd()
	if(strsplit(path.docs, "/")[[1]][1]==".."){
		tmp <- strsplit(path.docs, "/")[[1]][-1]
		if(length(tmp)) path.docs <- file.path(getwd(), paste0(tmp, collapse="/")) else stop("Check path.docs argument.")
	}
	for(i in 1:length(type)){
		if(type[i]=="pdf") origin <- "Rnw" else origin <- "Rmd"
		path.i <- file.path(path.docs, origin)
		infiles <- list.files(path.i, pattern=paste0("\\.", type[i], "$"), full=TRUE)
		if(length(infiles)){
			infiles <- infiles[basename(dirname(infiles))==origin]
			if(length(infiles)){
				if(type[i]=="html"){
					html.dirs <- gsub("\\.html", "_files", infiles)
					dirs <- list.dirs(path.i, recursive=FALSE)
					ind <- which(dirs %in% html.dirs)
					if(length(ind)){
						html.dirs <- dirs[ind]
						html.dirs.recur <- list.dirs(html.dirs)
						print(html.dirs.recur)
						for(p in 1:length(html.dirs.recur))	dir.create(gsub("/Rmd", "/html", html.dirs.recur[p]), recursive=TRUE, showWarnings=FALSE)
						subfiles <- unique(unlist(lapply(1:length(html.dirs.recur), function(p, path) list.files(path[p], full=TRUE), path=html.dirs.recur)))
						subfiles <- subfiles[!(subfiles %in% html.dirs.recur)]
						print(subfiles)
						file.copy(subfiles, gsub("/Rmd", "/html", subfiles), overwrite=TRUE)
						if(move) unlink(html.dirs, recursive=TRUE)
					}
				}
				outfiles <- file.path(path.docs, type[i], basename(infiles))
				if(move) file.rename(infiles, outfiles) else if(copy) file.copy(infiles, outfiles, overwrite=TRUE)
			}
		}
		if(type[i]=="pdf"){
			extensions <- c("TeX", "aux", "txt")
			pat <- paste0("^", rep(gsub("pdf", "", basename(infiles)), length(extensions)), rep(extensions, each=length(infiles)), "$")
			print(path.i)
			print(pat)
			latex.files <- sapply(1:length(pat), function(p, path, pat) list.files(path, pattern=pat[p], full=TRUE), path=path.i, pat=pat)
			print(latex.files)
			#if(remove.latex){
			#	file.remove(latex.files)
			#} else {
			#	dir.create(file.path(path.docs, latexDir), showWarnings=FALSE, recursive=TRUE)
			#	file.rename(latex.files, file.path(path.docs, latexDir, basename(latex.files)))
			#}
		}
	}
}

# @knitr fun_genNavbar
# Functions for Github project websites
genNavbar <- function(htmlfile="navbar.html", title, menu, submenus, files, title.url="index.html", home.url="index.html", site.url="", site.name="Github", include.home=FALSE){

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
	
	if(include.home) home <- paste0('<li><a href="', home.url, '">Home</a></li>\n          ') else home <- ""
	x <- paste0(
		'<div class="navbar navbar-default navbar-fixed-top">\n  <div class="navbar-inner">\n    <div class="container">\n      <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">\n        <span class="icon-bar"></span>\n        <span class="icon-bar"></span>\n        <span class="icon-bar"></span>\n      </button>\n      <a class="brand" href="', title.url, '">', title, '</a>\n      <div class="nav-collapse collapse">\n        <ul class="nav">\n          ',
		home,
		paste(sapply(1:length(menu), fillMenu, menu=menu, submenus=submenus, files=files), sep="", collapse="\n          "),
		'        </ul>\n        <ul class="nav pull-right">\n          <a class="btn btn-primary" href="', site.url, '">\n            <i class="fa fa-github fa-lg"></i>\n            ',site.name,'\n          </a>\n        </ul>\n      </div><!--/.nav-collapse -->\n    </div>\n  </div>\n</div>\n',
		collpase="")
	sink(htmlfile)
	cat(x)
	sink()
	x
}

# @knitr fun_genOutyaml
genOutyaml <- function(file, theme="cosmo", highlight="zenburn", lib=NULL, header=NULL, before_body=NULL, after_body=NULL){
	output.yaml <- paste0('html_document:\n  self_contained: false\n  theme: ', theme, '\n  highlight: ', highlight, '\n  mathjax: null\n  toc_depth: 2\n')
	if(!is.null(lib)) output.yaml <- paste0(output.yaml, '  lib_dir: ', lib, '\n')
	output.yaml <- paste0(output.yaml, '  includes:\n')
	if(!is.null(header)) output.yaml <- paste0(output.yaml, '    in_header: ', header, '\n')
	if(!is.null(before_body)) output.yaml <- paste0(output.yaml, '    before_body: ', before_body, '\n')
	if(!is.null(after_body)) output.yaml <- paste0(output.yaml, '    after_body: ', after_body, '\n')
	sink(file)
	cat(output.yaml)
	sink()
	output.yaml
}

# @knitr fun_genAppDiv
# Functions for Github user website
genAppDiv <- function(file="C:/github/leonawicz.github.io/assets/apps_container.html", type="apps", main="Shiny Apps",
	apps.url="http://shiny.snap.uaf.edu", github.url="https://github.com/ua-snap/shiny-apps/tree/master", apps.dir="C:/github/shiny-apps", img.loc="_images/cropped", ...){
	
	apps.img <- list.files(file.path(apps.dir, img.loc))
	apps <- sapply(strsplit(apps.img, "\\."), "[[", 1)
	x <- paste0('<div class="container">\n  <div class="row">\n    <div class="col-lg-12">\n      <div class="page-header">\n        <h3 id="', type, '">', main, '</h3>\n      </div>\n    </div>\n  </div>\n  ')
	
    fillRow <- function(i, ...){
		app <- apps[i]
	    app.url <- file.path(apps.url, app)
	    dots <- list(...)
	    if(is.null(dots$col)) col <- "warning" else col <- dots$col
	    if(is.null(dots$panel.main)) panel.main <- gsub("_", " ", app) else panel.main <- dots$panel.main
	    if(length(panel.main) > 1) panel.main <- panel.main[i]
	    x <- paste0('<div class="col-lg-4">
		  <div class="bs-component">
			<div class="panel panel-', col, '">
			  <div class="panel-heading"><h3 class="panel-title">', panel.main, '</h3>
			  </div>
			  <div class="panel-body"><a href="', app.url, '" target="_blank"><img src="', file.path(gsub("/tree/", "/raw/", github.url), img.loc, apps.img[i]), '" alt="', apps[i], '" width=100% height=200px></a><p></p>
				<div class="btn-group btn-group-justified">
				  <a href="', app.url, '" target="_blank" class="btn btn-success">Launch</a>
				  <a href="', file.path(github.url, app), '" target="_blank" class="btn btn-info">Github</a>
				</div>
			  </div>
			</div>
		  </div>
		</div>')
	}
	
	n <- length(apps)
	seq1 <- seq(1, n, by=3)
	y <- c()
	for(j in 1:length(seq1)){
		ind <- seq1[j]:(seq1[j] + 2)
		ind <- ind[ind %in% 1:n]
		y <- c(y, paste0('<div class="row">\n', paste0(sapply(ind, fillRow, ...), collapse="\n"), '</div>\n'))
	}
	z <- '</div>\n'
	sink(file)
	sapply(c(x, y, z), cat)
	sink()
	cat("div container html created for Shiny Apps.\n")
}

#genAppDiv()
#genAppDiv(panel.main=rep("Jussanothashinyapp", 18))

# @knitr fun_genPanelDiv
genPanelDiv <- function(outDir="C:/github/leonawicz.github.io/assets", type="projects", main="Projects",
	github.user="leonawicz", prjs.dir="C:/github", exclude=c("leonawicz.github.io", "shiny-apps"), img.loc="_images/cropped", ...){
	stopifnot(github.user %in% c("leonawicz", "ua-snap"))
	if(type=="apps"){
		filename <- "apps_container.html"
		web.url <- "http://shiny.snap.uaf.edu"
		gh.url.tail <- "shiny-apps/tree/master"
		target <- ' target="_blank"'
		go.label <- "Launch"
		prjs.dir <- file.path(prjs.dir, "shiny-apps")
		prjs.img <- list.files(file.path(prjs.dir, img.loc))
		prjs <- sapply(strsplit(prjs.img, "\\."), "[[", 1)
	}
	if(type=="projects"){
		filename <- "projects_container.html"
		web.url <- paste0("http://", github.user, ".github.io")
		gh.url.tail <- ""
		target <- ""
		go.label <- "Website"
		prjs <- list.dirs(prjs.dir, full=TRUE, recursive=FALSE)
		prjs <- prjs[!(basename(prjs) %in% exclude)]
		prjs.img <- sapply(1:length(prjs), function(i, a) list.files(file.path(a[i], "plots"), pattern=paste0("^_", basename(a)[i])), a=prjs)
		prjs <- basename(prjs)
	}
	gh.url <- file.path("https://github.com", github.user, gh.url.tail)
	x <- paste0('<div class="container">\n  <div class="row">\n    <div class="col-lg-12">\n      <div class="page-header">\n        <h3 id="', type, '">', main, '</h3>\n      </div>\n    </div>\n  </div>\n  ')
	
    fillRow <- function(i, ...){
		prj <- prjs[i]
		if(type=="apps") img.src <- file.path(gsub("/tree/", "/raw/", gh.url), img.loc, prjs.img[i])
		if(type=="projects") img.src <- file.path(gh.url, prj, "raw/master/plots", prjs.img[i])
	    web.url <- file.path(web.url, prj)
	    dots <- list(...)
	    if(is.null(dots$col)) col <- "warning" else col <- dots$col
	    if(is.null(dots$panel.main)) panel.main <- gsub("_", " ", prj) else panel.main <- dots$panel.main
	    if(length(panel.main) > 1) panel.main <- panel.main[i]
	    x <- paste0('<div class="col-lg-4">
		  <div class="bs-component">
			<div class="panel panel-', col, '">
			  <div class="panel-heading"><h3 class="panel-title">', panel.main, '</h3>
			  </div>
			  <div class="panel-body"><a href="', web.url, '"', target, '><img src="', img.src, '" alt="', prj, '" width=100% height=200px></a><p></p>
				<div class="btn-group btn-group-justified">
				  <a href="', web.url, '"', target, ' class="btn btn-success">', go.label, '</a>
				  <a href="', file.path(gh.url, prj), '" class="btn btn-info">Github</a>
				</div>
			  </div>
			</div>
		  </div>
		</div>')
	}
	
	n <- length(prjs)
	seq1 <- seq(1, n, by=3)
	y <- c()
	for(j in 1:length(seq1)){
		ind <- seq1[j]:(seq1[j] + 2)
		ind <- ind[ind %in% 1:n]
		y <- c(y, paste0('<div class="row">\n', paste0(sapply(ind, fillRow, ...), collapse="\n"), '</div>\n'))
	}
	z <- '</div>\n'
	sink(file.path(outDir, filename))
	sapply(c(x, y, z), cat)
	sink()
	cat("div container html file created.\n")
}
