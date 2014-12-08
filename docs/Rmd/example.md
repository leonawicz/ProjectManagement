# Project Management
Matthew Leonawicz  



## Example usage
This is how `projman` functions can be used to create and manipulate a project, using the `projman` project itself as an example.
The code below is not intended to be run directly, but serves as a guide.

## R code

### Create a project
Note that I use my own default path for storing a project when creating a new project.
See the `projman` [default objects](objects.html "default objects") and [creating a new project](func_new.html "new project") for more details.


```r
proj.name <- "ProjectManagement"  # Project name
proj.location <- matt.proj.path  # Use default file location

newProject(proj.name, proj.location, overwrite = T)  # create a new project

rfile.path <- file.path(matt.proj.path, proj.name, "code")  # path to R scripts

# generate Rmd files from existing R scripts using default yaml front-matter
genRmd(path = rfile.path, header = rmdHeader())
```

### Update a project
Functions can be used to create, read, or update. See [Rmd-related functions](func_rmd.html "Rmd-related functions").


```r
# update yaml front-matter only
genRmd(path = rfile.path, header = rmdHeader(), update.header = TRUE)

# obtain knitr code chunk names in existing R scripts
chunkNames(path = file.path(matt.proj.path, proj.name, "code"))

# append new knitr code chunk names found in existing R scripts to any Rmd
# files which are outdated
chunkNames(path = file.path(matt.proj.path, proj.name, "code"), append.new = TRUE)
```

### Prepare a project website
With some additional project-specific setup, files can be generated which will assist in creating a project website.
See [website-related functions](func_website.html "website-related functions").


```r
# Setup for generating a project website
proj.title <- "Project Management"
proj.menu <- c("projman", "R Code", "All Projects")

proj.submenu <- list(c("About projman", "Introduction", "Related items", "Example usage"), 
    c("Default objects", "divider", "Functions", "Start a new project", "Working with Rmd files", 
        "Make a project website"), c("Projects diagram", "divider", "About", 
        "Other"))

proj.files <- list(c("header", "proj_intro.html", "proj_sankey.html", "example.html"), 
    c("objects.html", "divider", "header", "func_new.html", "func_rmd.html", 
        "func_website.html"), c("proj_sankey.html", "divider", "proj_intro.html", 
        "proj_intro.html"))

proj.github <- "https://github.com/leonawicz/ProjectManagement"

# generate navigation bar html file common to all pages
genNavbar(htmlfile = file.path(proj.location, proj.name, "docs/Rmd/include/navbar.html"), 
    title = proj.title, menu = proj.menu, submenus = proj.submenu, files = proj.files, 
    home.url = "proj_intro.html", site.link = proj.github)

# generate _output.yaml file Note that external libraries are expected,
# stored in the 'libs' directory below
genOutyaml(file = file.path(proj.location, proj.name, "docs/Rmd/_output.yaml"), 
    lib = "libs", header = "in_header.html", before_body = "navbar.html")
```
