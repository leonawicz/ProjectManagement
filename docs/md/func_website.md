


### Functions: Project web sites

Some functions in this section are also used in the generation of Github user pages (see next section).
They appear here because they are used more generally for project pages even though some contain user page-specific code and arguments as well.
Functions in the subsequent section are used more exclusively for user pages generation.

#### buttonGroup
`buttonGroup` is a helper function for `genNavbar`. I used it to place social media buttons in the right side of the navigation bar at the top of a web page.
For project pages I tend to only include a Github button linking to the project repo.
For my Github user pages, I include more buttons.
The function generates an html snippet defining a group of buttons.
Typical use is to pass a list of the below arguments to `genNavbar`.

`txt` is a character vector of text to appear inside the button.
`urls` represents an accompanying vector of page urls.

`fa.icons=NULL` (default) means no Font Awesome icons will be included in the button to the left of the text.
A vector of icon names can be passed. The whole string is not required, only the relevant text following `fa-`.
For example, use `github` instead of `fa-github`.

The `colors` argument takes any of the following CSS theme-defined "colors": default, primary, success, info, warning, danger.
If `solid.group=TRUE`, a justified block button group will be defined.


```r
# Functions for Github websites
buttonGroup <- function(txt, urls, fa.icons = NULL, colors = "primary", solid.group = FALSE) {
    stopifnot(is.character(txt) & is.character(urls))
    n <- length(txt)
    stopifnot(length(urls) == n)
    stopifnot(colors %in% c("default", "primary", "success", "info", "warning", 
        "danger", "link"))
    stopifnot(n%%length(colors) == 0)
    if (is.null(fa.icons)) 
        icons <- vector("list", length(txt)) else if (is.character(fa.icons)) 
        icons <- as.list(fa.icons) else stop("fa.icons must be character or NULL")
    stopifnot(length(icons) == n)
    if (length(colors) < n) 
        colors <- rep(colors, length = n)
    
    btnlink <- function(i, txt, url, icon, col) {
        x <- paste0("<a class=\"btn btn-", col[i], "\" href=\"", url[i], "\">")
        y <- if (is.null(icon[[i]])) 
            "" else paste0("<i class=\"fa fa-", icon[[i]], " fa-lg\"></i>")
        z <- paste0(" ", txt[i], "</a>\n")
        paste0(x, y, z)
    }
    
    x <- if (solid.group) 
        "<div class=\"btn-group btn-group-justified\">\n" else ""
    y <- paste0(sapply(1:length(txt), btnlink, txt = txt, url = urls, icon = icons, 
        col = colors), collapse = "")
    z <- if (solid.group) 
        "</div>\n" else ""
    paste0(x, y, z)
}
```

#### genNavbar

`genNavbar` generates a navigation bar for a web page.
The html file created is generally written to the project's `docs/Rmd/include` directory.
However, if this function is used to create a navbar for a Github user web page, the html file should be stored in a sensible location inside the user pages repository, e.g., `leonawicz.github.io/assets`.

The common navigation bar html is included at the beginning of the body of the html for each web page in the project's website.
`menu` is a vector of names for each dropdown menu.
`submenus` is a list of vectors of menu options corresponding to each menu.
`files` is a similar list of vectors.
Each element is either an html file for a web page to be associated with the submenu link,
"header" to indicate the corresponding name in `submenus` is only a group label and not a link to a web page,
or "divider" to indicate placement of a bar for separating groups in a dropdown menu.

`theme` can be either `united` (default) or `cyborg`.
Both are from Bootswatch.
The function must apply some internal differentiation in the construction of the html navigation bar between themes.
This is currently the only `rpm` function which attempts to handle multiple Bootswatch themes with different CSS tags.

If `media.button.args=NULL` (default), only the Github button will be included, and then only if `site.name="Github"` and site.url is not blank.
I use this default for project pages and do not insert additional buttons.
For user pages, the same default will work.
Alternatively, a list of arguments can passed on to `buttonGroup`.
I have not checked yet to see if this also works for project pages.


```r
genNavbar <- function(htmlfile = "navbar.html", before_body = NULL, title, menu, 
    submenus, files, title.url = "index.html", home.url = "index.html", site.url = "", 
    site.name = "Github", media.button.args = NULL, include.home = FALSE) {
    ncs <- c("navbar-brand", "navbar-collapse collapse navbar-responsive-collapse", 
        "nav navbar-nav", "nav navbar-nav navbar-right", "container", "navbar-header", 
        "      </div>\n", "navbar-toggle", ".navbar-responsive-collapse", "")
    
    if (!is.null(media.button.args)) {
        media.buttons <- do.call(buttonGroup, media.button.args)
    } else if (site.name == "Github" & site.url != "") {
        media.buttons <- paste0("<a class=\"btn btn-link\" href=\"", site.url, 
            "\">\n            <i class=\"fa fa-github fa-lg\"></i>\n            ", 
            site.name, "\n          </a>\n")
    } else media.buttons <- ""
    
    fillSubmenu <- function(x, name, file) {
        dd.menu.header <- "dropdown-header"
        if (file[x] == "divider") 
            return("              <li class=\"divider\"></li>\n")
        if (file[x] == "header") 
            return(paste0("              <li class=\"", dd.menu.header, "\">", 
                name[x], "</li>\n"))
        paste0("              <li><a href=\"", file[x], "\">", name[x], "</a></li>\n")
    }
    
    fillMenu <- function(x, menu, submenus, files) {
        m <- menu[x]
        gs.menu <- gsub(" ", "-", tolower(m))
        s <- submenus[[x]]
        f <- files[[x]]
        if (s[1] == "empty") {
            y <- paste0("<li><a href=\"", f, "\">", m, "</a></li>\n")
        } else {
            y <- paste0("<li class=\"dropdown\">\n            <a href=\"", gs.menu, 
                "\" class=\"dropdown-toggle\" data-toggle=\"dropdown\">", m, 
                " <b class=\"caret\"></b></a>\n            <ul class=\"dropdown-menu\">\n", 
                paste(sapply(1:length(s), fillSubmenu, name = s, file = f), 
                  sep = "", collapse = ""), "            </ul>\n", collapse = "")
        }
    }
    
    if (include.home) 
        home <- paste0("<li><a href=\"", home.url, "\">Home</a></li>\n          ") else home <- ""
    x <- paste0("<div class=\"navbar navbar-default navbar-fixed-top\">\n  <div class=\"", 
        ncs[5], "\">\n    <div class=\"", ncs[6], "\">\n      <button type=\"button\" class=\"", 
        ncs[8], "\" data-toggle=\"collapse\" data-target=\"", ncs[9], "\">\n        <span class=\"icon-bar\"></span>\n        <span class=\"icon-bar\"></span>\n        <span class=\"icon-bar\"></span>\n      </button>\n      <a class=\"", 
        ncs[1], "\" href=\"", title.url, "\">", title, "</a>\n", ncs[7], "      <div class=\"", 
        ncs[2], "\">\n        <ul class=\"", ncs[3], "\">\n          ", home, 
        paste(sapply(1:length(menu), fillMenu, menu = menu, submenus = submenus, 
            files = files), sep = "", collapse = "\n          "), "        </ul>\n        <ul class=\"", 
        ncs[4], "\">\n          ", media.buttons, "        </ul>\n      </div><!--/.nav-collapse -->\n    </div>\n  ", 
        ncs[10], "</div>\n", collpase = "")
    
    if (!is.null(before_body)) 
        x <- paste0(readLines(before_body), x)
    
    sink(htmlfile)
    cat(x)
    sink()
    x
}
```

#### genOutyaml

`genOutyaml` generates the `_out.yaml` file for yaml front-matter common to all html files in the project website.
The file should be written to the project's `docs/Rmd` directory.
`lib` specifies the library directory for any associated files.
yaml `includes` for external html common to all project web pages in the site can also be specified with `header`, `before_body`, and `after_body`.
These can be specified by file basename only (no path) and the function assumes these files are in the `docs/Rmd/include` directory.
At this time all external libraries must be provided by the user, for example in `docs/Rmd/libs`.
It is recommended. See the project repo [gh-pages](https://github.com/leonawicz/ProjectManagement/tree/gh-pages "gh-pages") branch for an example.


```r
genOutyaml <- function(file, theme = "cosmo", highlight = "zenburn", lib = NULL, 
    header = NULL, before_body = NULL, after_body = NULL) {
    output.yaml <- paste0("html_document:\n  self_contained: false\n  theme: ", 
        theme, "\n  highlight: ", highlight, "\n  mathjax: null\n  toc_depth: 2\n")
    if (!is.null(lib)) 
        output.yaml <- paste0(output.yaml, "  lib_dir: ", lib, "\n")
    output.yaml <- paste0(output.yaml, "  includes:\n")
    if (!is.null(header)) 
        output.yaml <- paste0(output.yaml, "    in_header: ", header, "\n")
    if (!is.null(before_body)) 
        output.yaml <- paste0(output.yaml, "    before_body: ", before_body, 
            "\n")
    if (!is.null(after_body)) 
        output.yaml <- paste0(output.yaml, "    after_body: ", after_body, "\n")
    sink(file)
    cat(output.yaml)
    sink()
    output.yaml
}
```
