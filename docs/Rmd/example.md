# Project Management
Matthew Leonawicz  



## Example usage
This is how `projman` functions can be used to create and manipulate a project, using the `projman` project itself as an example.
The code below is not intended to be run directly, but servers as a guide.

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


