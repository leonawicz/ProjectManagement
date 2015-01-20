


### Functions: Project creation

#### newProject
`newProject` creates a new named project directory structure at the specified file path.
If a directory with this project name already exists in this location on the file system and `overwrite=FALSE`, the function will abort.
Default project subdirectories are created unless a different vector of folder names is explicitly passed to `newProject`.
If one of the subdirectories is `docs` then the default vector of subdirectories under `docs` is also created.
This argument can also be set explicitly.
The current function only creates directories, not files, so `overwrite=TRUE` is safe to use on any existing project.


```r
newProject <- function(name, path, dirs = c("code", "data", "docs", "plots", 
    "workspaces"), docs.dirs = c("diagrams", "ioslides", "notebook", "Rmd/include", 
    "md", "html", "Rnw", "pdf", "timeline", "tufte"), overwrite = FALSE) {
    
    stopifnot(is.character(name))
    name <- file.path(path, name)
    if (file.exists(name) && !overwrite) 
        stop("This project already exists.")
    dir.create(name, recursive = TRUE, showWarnings = FALSE)
    if (!file.exists(name)) 
        stop("Directory appears invalid.")
    
    path.dirs <- file.path(name, dirs)
    sapply(path.dirs, dir.create, showWarnings = FALSE)
    path.docs <- file.path(name, "docs", docs.dirs)
    if ("docs" %in% dirs) 
        sapply(path.docs, dir.create, recursive = TRUE, showWarnings = FALSE)
    if (overwrite) 
        cat("Project directories updated.\n") else cat("Project directories created.\n")
}
```
