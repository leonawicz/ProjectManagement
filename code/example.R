# @knitr ex_create_project
source("C:/github/ProjectManagement/code/projman.R") # Eventually load projman package instead
proj.name <- "ProjectManagement" # Project name
proj.location <- matt.proj.path # Use default file location

docDir <- c("Rmd/include", "md", "html", "Rnw", "pdf", "timeline")
newProject(proj.name, proj.location, docs.dirs=docDir, overwrite=T) # create a new project

rfile.path <- file.path(proj.location, proj.name, "code") # path to R scripts
docs.path <- file.path(proj.location, proj.name, "docs")
rmd.path <- file.path(docs.path, "Rmd")

# generate Rmd files from existing R scripts using default yaml front-matter
genRmd(path=rfile.path, header=rmdHeader())

# @knitr ex_update_project
# update yaml front-matter only
genRmd(path=rfile.path, header=rmdHeader(), knitrSetupChunk=rmdknitrSetup(), update.header=TRUE)

# obtain knitr code chunk names in existing R scripts
chunkNames(path=file.path(proj.location, proj.name, "code"))

# append new knitr code chunk names found in existing R scripts to any Rmd files which are outdated
chunkNames(path=file.path(proj.location, proj.name, "code"), append.new=TRUE)

# if also making PDFs for a project, speed up the Rmd to Rnw file conversion/duplication
#rmd2rnw(path=file.path(proj.location, proj.name, "Rmd")) # function under development

# @knitr ex_website
# Setup for generating a project website
index.url <- file.path(rmd.path, "proj_intro.html") # temporary
file.copy(index.url, file.path(rmd.path, "index.html"))

proj.title <- "Project Management"
proj.menu <- c("projman", "R Code", "All Projects")

proj.submenu <- list(
	c("About projman", "Introduction", "Related items", "Example usage"),
	c("Default objects", "divider", "Functions", "Start a new project", "Working with Rmd files", "Make a project website", "Github user website"),
	c("Projects diagram", "divider", "About", "Other")
)

proj.files <- list(
	c("header", "proj_intro.html", "code_sankey.html", "example.html"),
	c("objects.html", "divider", "header", "func_new.html", "func_rmd.html", "func_website.html", "func_user_website.html"),
	c("proj_sankey.html", "divider", "proj_intro.html", "proj_intro.html")
)

proj.github <- file.path("https://github.com/leonawicz", proj.name)

# generate navigation bar html file common to all pages
genNavbar(htmlfile=file.path(proj.location, proj.name, "docs/Rmd/include/navbar.html"), title=proj.title, menu=proj.menu, submenus=proj.submenu, files=proj.files, title.url="index.html", home.url="index.html", site.url=proj.github, include.home=FALSE)

# generate _output.yaml file
# Note that external libraries are expected, stored in the "libs" directory below
yaml.out <- file.path(proj.location, proj.name, "docs/Rmd/_output.yaml")
libs <- "include/libs"
common.header <- "include/in_header.html"
genOutyaml(file=yaml.out, lib=libs, header=common.header, before_body="include/navbar.html")

# @knitr knit_setup
library(rmarkdown)
library(knitr)
setwd(rmd.path)

# R scripts
#files.r <- list.files("../../code", pattern=".R$", full=T)

# Rmd files
files.Rmd <- list.files(pattern=".Rmd$", full=T)

# potential non-Rmd directories for writing various output files
#outtype <- file.path(dirname(getwd()), list.dirs("../", full=F, recursive=F))
#outtype <- outtype[basename(outtype)!="Rmd"]

# @knitr save
# write all yaml front-matter-specified outputs to Rmd directory for all Rmd files
lapply(files.Rmd, render, output_format="all")

moveDocs(path.docs=docs.path)
