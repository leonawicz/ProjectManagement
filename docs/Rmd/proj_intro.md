# Project Management
Matthew Leonawicz  

## Introduction
This is a project management project.
The aim of this project is the development of convenient **R**-related project management tools.

### Motivation
I am working on these tools to enhance my own workflow across multiple **R** projects.

### Details
**R** code for the project will be compiled into an **R** package, `projman` for easy use.
This is a personal package and will not be available anywhere but my github repository,
but you are welcome to explore the package and functions.
It is unlikely that you would manage your **R** projects in the same manner that I do,
but if you do, or just want some ideas, feel free to explore.

#### Capabilities
`projman` can create a new project. This essentially generates a specific directory structure which I use often to manage project files.
For an existing project, once **R** scripts have been created, `projman` can generate template Rmd files for each.
For existing Rmd files, `projman` can conveniently append these **R** Markdown files with a list of any new `knitr` code chunk names
in project **R** scripts being developed which have not yet been included in the respective Rmd files.

#### Limitations
While `projman` assists with project documentation, this mainly takes the form of file generation and appending.
Documentation is unique to every project of course. Every script is different.
The most that is possible is to auto-fill commonly used code chunk names and metadata.
Each document must be written individually by the author, but when a project has many **R** scripts requiring documentation,
it is nice to not have to create all the corresponding Rmd files by hand and copy and paste generic contents.

The project management code is not yet in package form.
Many additional features are yet to be incorporated.
Generic code relating to the further processing of Rmd files into various other output files via `rmarkdown` and `knitr` will fold into this project,
but this has not been done yet.
