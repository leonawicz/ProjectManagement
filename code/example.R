# @knitr ex_create_project
proj.name <- "ProjectManagement" # Project name
proj.location <- matt.proj.path # Use default file location

newProject(proj.name, proj.location, overwrite=T) # create a new project

rfile.path <- file.path(matt.proj.path, proj.name, "code") # path to R scripts

# generate Rmd files from existing R scripts using default yaml front-matter
genRmd(path=rfile.path, header=rmdHeader())

# @knitr ex_update_project
# update yaml front-matter only
genRmd(path=rfile.path, header=rmdHeader(), update.header=TRUE)

# obtain knitr code chunk names in existing R scripts
chunkNames(path=file.path(matt.proj.path, proj.name, "code"))

# append new knitr code chunk names found in existing R scripts to any Rmd files which are outdated
chunkNames(path=file.path(matt.proj.path, proj.name, "code"), append.new=TRUE)

# @knitr ex_website
# Setup for generating a project website
proj.title <- "Project Management"
proj.menu <- c("projman", "R Code", "All Projects")

proj.submenu <- list(
	c("About projman", "Introduction", "Related items", "Example usage"),
	c("Default objects", "divider", "Functions", "Start a new project", "Working with Rmd files", "Make a project website"),
	c("Projects diagram", "divider", "About", "Other")
)

proj.files <- list(
	c("header", "proj_intro.html", "code_sankey.html", "example.html"),
	c("objects.html", "divider", "header", "func_new.html", "func_rmd.html", "func_website.html"),
	c("proj_sankey.html", "divider", "proj_intro.html", "proj_intro.html")
)

proj.github <- "https://github.com/leonawicz/ProjectManagement"

# generate navigation bar html file common to all pages
genNavbar(htmlfile=file.path(proj.location, proj.name, "docs/Rmd/include/navbar.html"), title=proj.title, menu=proj.menu, submenus=proj.submenu, files=proj.files, title.url="proj_intro.html", home.url="proj_intro.html", site.url=proj.github)

# generate _output.yaml file
# Note that external libraries are expected, stored in the "libs" directory below
genOutyaml(file=file.path(proj.location, proj.name, "docs/Rmd/_output.yaml"), lib="libs", header="in_header.html", before_body="navbar.html")
