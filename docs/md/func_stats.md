


### Functions: Project statistics

#### getProjectStats
`getProjectStats` parses text from **R** project scripts and documentation files to return basic descriptive statistics and data including:

* total number of files
* number of **R** scripts
* number of unique Rmd documents (Rnw companions, or knitted documents such as html, md or pdf are ignored)
* number of lines of code
* number of lines of documentation
* number of unique **R** functions defined in the global environment by the parsed scripts
* a 2-column matrix describing the hierarchical chain of project functions, to be used, e.g., in a directed graph or tree diagram

Functions defined internal to other project functions are excluded entirely.
Of the list of globally defined functions, only these functions are checked for internal references to other functions.
Likewise, only these functions are considered as possible nested references.

`getProjectStats` uses unsophisticated text parsing and in places relies of some excessively strong assumptions about how my **R** code is written.
It does not require loading scripts into an **R** workspace or checking object modes and environments.
See the `foodweb` function in the `mvbutils` package for something along these lines.
It sounds completely unrelated, I know, but it may be just what you are looking for.

Regarding strong assumptions, for example, although the first line of a function is easy to find,
I must search for the closing curly brace of a function in order to know the sequence of lines in a file the function pertains to.
There is risk of finding the closure to a `for` loop instead.
I avoid this kind of problem by taking the first closing curly brace following a function's opening line, which also meets the requirement of being a single-character line.
If a for loop occurs inside this function, my own style is to tab inward to make the code more readable,
so a loop ending with a closing curly brace would never be a single-character line.
The brace would at least be preceded by one or more spaces if not one or more a tab characters.
I can only expect such strong rules to work for my own code.

On the other hand, sometimes functions are on a single line, and may have no curly braces at all.
My code below would fail in such cases, still seeking a closing brace when there isn't one, either returning improper function line indices or throwing an error.

I would really like to have a function which returns hierarchical data describing the reactivity chain of an entire Shiny app, but I do not know how to do this.
Also, at this time I have not yet added any code for simply parsing text from **R** scripts to count the number of instances of reactive expressions and other Shiny code elements of interest.


```r
# Compile project code and documentation statistics and other metadataR
# Count R scripts, standard functions, lines of code, hierarchical function
# tree, number of Rmd documents, lines of documentation, Shiny app reactive
# expressions not yet included, e.g., input references, output references,
# render* calls other references of interest in the code, e.g., number of
# conditional panels in a Shiny app These instances would be easy to count
# but a hierarchical reactive elements tree would be challenging 'type'
# argument not currently in use
getProjectStats <- function(path, type = c("project", "app"), code = TRUE, docs = TRUE, 
    exclude = NULL) {
    
    if (!(code | docs)) 
        stop("At least one of 'code' or 'docs' must be TRUE.")
    r.files <- if (code) 
        list.files(path, pattern = ".R$", full = TRUE, recursive = TRUE) else NULL
    rmd.files <- if (docs) 
        list.files(path, pattern = ".Rmd$", full = TRUE, recursive = TRUE) else NULL
    
    getFunctionInfo <- function(x, func.names = NULL, func.lines = NULL) {
        if (is.null(func.names) & is.null(func.lines)) {
            x.split <- strsplit(gsub(" ", "", x), "<-function\\(")
            func.ind <- which(sapply(x.split, length) > 1 & !(substr(x, 1, 1) %in% 
                c(" ", "\t")))
            n <- length(func.ind)
            func.names <- if (n > 0) 
                sapply(x.split[func.ind], "[[", 1) else stop("No functions found.")
            func.close <- rep(NA, n)
            for (i in 1:n) {
                func.ind2 <- if (i < n) 
                  min(func.ind[i + 1] - 1, length(x)) else length(x)
                ind <- func.ind[i]:func.ind2
                func.close[i] <- ind[which(nchar(x[ind]) == 1 & x[ind] == "}")[1]]
            }
            func.lines <- mapply(seq, func.ind, func.close)
            if (!is.list(func.lines)) 
                func.lines <- as.list(data.frame(func.lines))
            return(list(func.names = func.names, func.lines = func.lines, n.func = n))
        } else {
            m <- c()
            n <- length(func.names)
            for (i in 1:n) {
                func.ref <- rep(NA, n)
                for (j in c(1:n)[-i]) {
                  x.tmp <- x[func.lines[[i]]]
                  x.tmp <- gsub(paste0(func.names[j], "\\("), "_1_SOMETHING_TO_SPLIT_ON_2_", 
                    x.tmp)  # standard function usage
                  x.tmp <- gsub(paste0("do.call\\(", func.names[j]), "_1_SOMETHING_TO_SPLIT_ON_2_", 
                    x.tmp)  # function reference inside do.call()
                  x.tmp <- gsub(paste0(func.names[j], ","), "_1_SOMETHING_TO_SPLIT_ON_2_", 
                    x.tmp)  # function reference followed by mere comma, e.g., in *apply functions: NOT IDEAL
                  x.tmp.split <- strsplit(x.tmp, "SOMETHING_TO_SPLIT_ON")
                  func.ref[j] <- any(sapply(x.tmp.split, length) > 1)
                }
                m.tmp <- if (any(func.ref, na.rm = TRUE)) 
                  cbind(func.names[i], func.names[which(func.ref)]) else cbind(func.names[i], NA)
                m <- rbind(m, m.tmp)
            }
            return(flow = m)
        }
    }
    
    if (is.character(exclude) & length(r.files)) 
        r.files <- r.files[!(basename(r.files) %in% exclude)]
    n.scripts <- length(r.files)
    if (n.scripts > 0) {
        l <- unlist(lapply(r.files, readLines))
        n.codelines <- length(l[l != ""])
        func.info <- getFunctionInfo(l)
        func.names <- func.info$func.names
        n.func <- func.info$n.func
        func.mat <- getFunctionInfo(l, func.names = func.names, func.lines = func.info$func.lines)
    } else {
        n.codelines <- n.func <- 0
        func.names <- func.mat <- NULL
    }
    
    if (is.character(exclude) & length(rmd.files)) 
        rmd.files <- rmd.files[!(basename(r.files) %in% exclude)]
    n.docs <- length(rmd.files)
    if (n.docs > 0) {
        l <- unlist(lapply(rmd.files, readLines))
        n.doclines <- length(l[l != ""])
    } else {
        n.doclines <- 0
    }
    
    total.files <- length(list.files(path, recursive = TRUE))
    
    return(list(total.files = total.files, n.docs = n.docs, n.doclines = n.doclines, 
        n.scripts = n.scripts, n.codelines = n.codelines, n.func = n.func, func.mat = func.mat))
}
```
