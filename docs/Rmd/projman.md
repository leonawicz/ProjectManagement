# Project Management
Matthew Leonawicz  




## Introduction
This is a project management project.
While current projects are shown in the chart below, the aim of this project is the development of convenient **R**-related project management tools.

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

## Related items
Currently there is only this unpackaged **R** script and accompanying code for a projects hierarchy diagram.
No additional related items are available at this time, but those referenced above will eventually be included.

### Files and Data
This project does not use any data. `sankey.R` is used to produce of project hierarchy diagram of my current projects.

### Code flow
The Sankey diagram has become part of project management.
Each project has its own, detailing the relationships among **R** code and data relevent to the project,
and in some cases, how they relate to code and data files which are more general and span multiple projects.
This diagram be available for this project once more project code has been developed.

### Current projects
Here is a project hierarchy diagram showing the relationships among all my current projects.



<iframe srcdoc=' &lt;!doctype HTML&gt;
&lt;meta charset = &#039;utf-8&#039;&gt;
&lt;html&gt;
  &lt;head&gt;
    &lt;link rel=&#039;stylesheet&#039; href=&#039;http://timelyportfolio.github.io/rCharts_d3_sankey/css/sankey.css&#039;&gt;
    
    &lt;script src=&#039;http://d3js.org/d3.v3.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;http://timelyportfolio.github.io/rCharts_d3_sankey/js/sankey.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    
    &lt;style&gt;
    .rChart {
      display: block;
      margin-left: auto; 
      margin-right: auto;
      width: 900px;
      height: 800px;
    }  
    &lt;/style&gt;
    
  &lt;/head&gt;
  &lt;body &gt;
    
    &lt;div id = &#039;chart16c2650191a&#039; class = &#039;rChart d3_sankey&#039;&gt;&lt;/div&gt;    
    ï»¿&lt;!--Attribution:
Mike Bostock https://github.com/d3/d3-plugins/tree/master/sankey
Mike Bostock http://bost.ocks.org/mike/sankey/
--&gt;

&lt;script&gt;
(function(){
var params = {
 &quot;dom&quot;: &quot;chart16c2650191a&quot;,
&quot;width&quot;:    900,
&quot;height&quot;:    800,
&quot;data&quot;: {
 &quot;source&quot;: [ &quot;Collaborators&quot;, &quot;Collaborators&quot;, &quot;Collaborators&quot;, &quot;Collaborators&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Alec&quot;, &quot;Angie&quot;, &quot;Angie&quot;, &quot;Bob&quot;, &quot;Angie&quot;, &quot;Bob&quot;, &quot;Alfresco Outputs&quot;, &quot;Alfresco Outputs&quot;, &quot;Alfresco Outputs&quot;, &quot;SNAP Data QA/QC&quot;, &quot;SNAP Data QA/QC&quot;, &quot;SNAP Data QA/QC&quot;, &quot;SNAP Data QA/QC&quot;, &quot;Spatial Lightning Analysis&quot;, &quot;Spatial Lightning Analysis&quot;, &quot;Spatial Lightning Analysis&quot;, &quot;Sea Ice Edge Maps and Spinoff Projects&quot;, &quot;Sea Ice Edge Maps and Spinoff Projects&quot;, &quot;Training/Supervision&quot;, &quot;Training/Supervision&quot;, &quot;Randscape Development&quot;, &quot;Randscape Development&quot;, &quot;Effective Spatial Scale Analysis&quot;, &quot;Effective Spatial Scale Analysis&quot;, &quot;NWT/Comm. Charts DS&quot;, &quot;Alfresco Noatak&quot;, &quot;Alfresco Statewide&quot;, &quot;Data Extraction and Uncertainty Analysis&quot;, &quot;Data Extraction and Uncertainty Analysis&quot;, &quot;Data Extraction and Uncertainty Analysis&quot;, &quot;Data Extraction and Uncertainty Analysis&quot; ],
&quot;target&quot;: [ &quot;Paul&quot;, &quot;Alec&quot;, &quot;Angie&quot;, &quot;Bob&quot;, &quot;CMIP3/CMIP5 GCM Comparisons&quot;, &quot;Effective Spatial Scale Analysis&quot;, &quot;Randscape Development&quot;, &quot;Alfresco Outputs&quot;, &quot;Projman&quot;, &quot;SNAP Data QA/QC&quot;, &quot;Training/Supervision&quot;, &quot;R Shiny Apps General Maintenance&quot;, &quot;New App Development&quot;, &quot;SNAP Tech Blog&quot;, &quot;Continuing Education&quot;, &quot;FRP/FRI Scale-Conditional Alfresco Maps&quot;, &quot;Moose Project&quot;, &quot;Alfresco Noatak&quot;, &quot;Alfresco Statewide&quot;, &quot;Spatial Lightning Analysis&quot;, &quot;Data Extraction and Uncertainty Analysis&quot;, &quot;Growing Season&quot;, &quot;Mussel Project&quot;, &quot;Land Carbon&quot;, &quot;Alfresco Noatak&quot;, &quot;Alfresco Statewide&quot;, &quot;Spatial Lightning Analysis&quot;, &quot;Data Extraction and Uncertainty Analysis&quot;, &quot;Growing Season&quot;, &quot;Mussel Project&quot;, &quot;Land Carbon&quot;, &quot;Alfresco CRU/GCM Experimental Design&quot;, &quot;Bird Project&quot;, &quot;NWT/Comm. Charts DS&quot;, &quot;Sea Ice Edge Maps and Spinoff Projects&quot;, &quot;Shiny App Server Migration&quot;, &quot;Alfresco CRU/GCM Experimental Design&quot;, &quot;Alfresco CRU/GCM Experimental Design&quot;, &quot;Bird Project&quot;, &quot;NWT/Comm. Charts DS&quot;, &quot;NWT/Comm. Charts DS&quot;, &quot;Sea Ice Edge Maps and Spinoff Projects&quot;, &quot;Shiny App Server Migration&quot;, &quot;CMIP3/CMIP5 GCM Comparisons&quot;, &quot;Land Carbon&quot;, &quot;Bird Project&quot;, &quot;Alfresco Outputs&quot;, &quot;CMIP3/CMIP5 GCM Comparisons&quot;, &quot;Alfresco CRU/GCM Experimental Design&quot;, &quot;NWT/Comm. Charts DS&quot;, &quot;Alfresco Noatak&quot;, &quot;Alfresco Statewide&quot;, &quot;Randscape Development&quot;, &quot;Randscape Development&quot;, &quot;Alfresco Outputs&quot;, &quot;Bird Project&quot;, &quot;NWT/Comm. Charts DS&quot;, &quot;Alfresco Outputs&quot;, &quot;Effective Spatial Scale Analysis&quot;, &quot;Alfresco Outputs&quot;, &quot;FRP/FRI Scale-Conditional Alfresco Maps&quot;, &quot;CMIP3/CMIP5 GCM Comparisons&quot;, &quot;FRP/FRI Scale-Conditional Alfresco Maps&quot;, &quot;FRP/FRI Scale-Conditional Alfresco Maps&quot;, &quot;CMIP3/CMIP5 GCM Comparisons&quot;, &quot;Effective Spatial Scale Analysis&quot;, &quot;Randscape Development&quot;, &quot;Alfresco Outputs&quot; ],
&quot;value&quot;: [      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1 ] 
},
&quot;nodeWidth&quot;:     15,
&quot;nodePadding&quot;:     10,
&quot;layout&quot;:     32,
&quot;margin&quot;: {
 &quot;right&quot;:     20,
&quot;left&quot;:     20,
&quot;bottom&quot;:     20,
&quot;top&quot;:     20 
},
&quot;title&quot;: &quot;Matt&#039;s Projects&quot;,
&quot;id&quot;: &quot;chart16c2650191a&quot; 
};

params.units ? units = &quot; &quot; + params.units : units = &quot;&quot;;

//hard code these now but eventually make available
var formatNumber = d3.format(&quot;0,.0f&quot;),    // zero decimal places
    format = function(d) { return formatNumber(d) + units; },
    color = d3.scale.category20();

if(params.labelFormat){
  formatNumber = d3.format(&quot;.2%&quot;);
}

var svg = d3.select(&#039;#&#039; + params.id).append(&quot;svg&quot;)
    .attr(&quot;width&quot;, params.width)
    .attr(&quot;height&quot;, params.height);
    
var sankey = d3.sankey()
    .nodeWidth(params.nodeWidth)
    .nodePadding(params.nodePadding)
    .layout(params.layout)
    .size([params.width,params.height]);
    
var path = sankey.link();
    
var data = params.data,
    links = [],
    nodes = [];
    
//get all source and target into nodes
//will reduce to unique in the next step
//also get links in object form
data.source.forEach(function (d, i) {
    nodes.push({ &quot;name&quot;: data.source[i] });
    nodes.push({ &quot;name&quot;: data.target[i] });
    links.push({ &quot;source&quot;: data.source[i], &quot;target&quot;: data.target[i], &quot;value&quot;: +data.value[i] });
}); 

//now get nodes based on links data
//thanks Mike Bostock https://groups.google.com/d/msg/d3-js/pl297cFtIQk/Eso4q_eBu1IJ
//this handy little function returns only the distinct / unique nodes
nodes = d3.keys(d3.nest()
                .key(function (d) { return d.name; })
                .map(nodes));

//it appears d3 with force layout wants a numeric source and target
//so loop through each link replacing the text with its index from node
links.forEach(function (d, i) {
    links[i].source = nodes.indexOf(links[i].source);
    links[i].target = nodes.indexOf(links[i].target);
});

//now loop through each nodes to make nodes an array of objects rather than an array of strings
nodes.forEach(function (d, i) {
    nodes[i] = { &quot;name&quot;: d };
});

sankey
  .nodes(nodes)
  .links(links)
  .layout(params.layout);
  
var link = svg.append(&quot;g&quot;).selectAll(&quot;.link&quot;)
  .data(links)
.enter().append(&quot;path&quot;)
  .attr(&quot;class&quot;, &quot;link&quot;)
  .attr(&quot;d&quot;, path)
  .style(&quot;stroke-width&quot;, function (d) { return Math.max(1, d.dy); })
  .sort(function (a, b) { return b.dy - a.dy; });

link.append(&quot;title&quot;)
  .text(function (d) { return d.source.name + &quot; â†’ &quot; + d.target.name + &quot;\n&quot; + format(d.value); });

var node = svg.append(&quot;g&quot;).selectAll(&quot;.node&quot;)
  .data(nodes)
.enter().append(&quot;g&quot;)
  .attr(&quot;class&quot;, &quot;node&quot;)
  .attr(&quot;transform&quot;, function (d) { return &quot;translate(&quot; + d.x + &quot;,&quot; + d.y + &quot;)&quot;; })
.call(d3.behavior.drag()
  .origin(function (d) { return d; })
  .on(&quot;dragstart&quot;, function () { this.parentNode.appendChild(this); })
  .on(&quot;drag&quot;, dragmove));

node.append(&quot;rect&quot;)
  .attr(&quot;height&quot;, function (d) { return d.dy; })
  .attr(&quot;width&quot;, sankey.nodeWidth())
  .style(&quot;fill&quot;, function (d) { return d.color = color(d.name.replace(/ .*/, &quot;&quot;)); })
  .style(&quot;stroke&quot;, function (d) { return d3.rgb(d.color).darker(2); })
.append(&quot;title&quot;)
  .text(function (d) { return d.name + &quot;\n&quot; + format(d.value); });

node.append(&quot;text&quot;)
  .attr(&quot;x&quot;, -6)
  .attr(&quot;y&quot;, function (d) { return d.dy / 2; })
  .attr(&quot;dy&quot;, &quot;.35em&quot;)
  .attr(&quot;text-anchor&quot;, &quot;end&quot;)
  .attr(&quot;transform&quot;, null)
  .text(function (d) { return d.name; })
.filter(function (d) { return d.x &lt; params.width / 2; })
  .attr(&quot;x&quot;, 6 + sankey.nodeWidth())
  .attr(&quot;text-anchor&quot;, &quot;start&quot;);

// the function for moving the nodes
  function dragmove(d) {
    d3.select(this).attr(&quot;transform&quot;, 
        &quot;translate(&quot; + (
                   d.x = Math.max(0, Math.min(params.width - d.dx, d3.event.x))
                ) + &quot;,&quot; + (
                   d.y = Math.max(0, Math.min(params.height - d.dy, d3.event.y))
                ) + &quot;)&quot;);
        sankey.relayout();
        link.attr(&quot;d&quot;, path);
  }
})();
&lt;/script&gt;
    
    
    &lt;script&gt;
      var cscale = d3.scale.category20b();
    
      // to be specific in case you have more than one chart
      d3.selectAll(&#039;#chart16c2650191a svg path.link&#039;)
        .style(&#039;stroke&#039;, function(d){
          //here we will use the source color
          //if you want target then sub target for source
          //or if you want something other than gray
          //supply a constant
          //or use a categorical scale or gradient
          //return d.source.color;
          return cscale(d.source.name);
        })
       //note no changes were made to opacity
       //to do uncomment below but will affect mouseover
       //so will need to define mouseover and mouseout
       //happy to show how to do this also
       // .style(&#039;stroke-opacity&#039;, .7)
      d3.selectAll(&#039;#chart16c2650191a svg .node rect&#039;)
        .style(&#039;fill&#039;, function(d){
          return cscale(d.name)
        })
        .style(&#039;stroke&#039;, &#039;none&#039;)
    &lt;/script&gt;
        
  &lt;/body&gt;
&lt;/html&gt; ' scrolling='no' frameBorder='0' seamless class='rChart  http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey  ' id='iframe-chart16c2650191a'> </iframe>
 <style>iframe.rChart{ width: 100%; height: 400px;}</style>
<style>iframe.rChart{ width: 100%; height: 840px;}</style>

## **R** code

### Template objects
Character string objects are defined which are used to fill templates when generating new files for a project.
A tentative default path is also included since this code relates to my own work.


```r
# For package 'projman'

# data
rmd.knitr.setup <- "\n```{r knitr_setup, echo=FALSE}\nopts_chunk$set(cache=FALSE, eval=FALSE, tidy=TRUE, messages=FALSE, warnings=FALSE)\nread_chunk(\"\")\n```\n"

rmd.template <- "\n\n## Introduction\nADD_TEXT_HERE\n\n### Motivation\nADD_TEXT_HERE\n\n### Details\nADD_TEXT_HERE\n\n#### Capabilities\nADD_TEXT_HERE\n\n#### Limitations\nADD_TEXT_HERE\n\n## Related items\n\n### Files and Data\nADD_TEXT_HERE\n\n### Code flow\nADD_TEXT_HERE\n\n```{r code_sankey, echo=F, eval=T}\n```\n\n```{r code_sankey_embed, echo=F, eval=T, comment=NA, results=\"asis\", tidy=F}\n```\n\n## R code\n\n### Setup\nADD_TEXT_HERE: EXAMPLE\nSetup consists of loading required **R** packages and additional files, preparing any command line arguments for use, and defining functions and other **R** objects.\n\n"

# default path
matt.proj.path <- "C:/github"
```

### Package functions
Functions are defined for creating new projects, generating Rmd files for project **R** scripts,
and appending these **R** Markdown files with updated information from the corresponding **R** scripts as their development continues.
Additional functions will be incorporated later.

#### newProject
`newProject` creates a new named project directory structure at the specified file path.
If a directory with this project name already exists in this location on the file system and `overwrite=FALSE`, the function will abort.
Default project subdirectories are created unless a different vector of folder names is explicitly passed to ```newProject```.
If one of the subdirectories is `docs` then the default vector of subdirectories under `docs` is also created.
This argument can also be set explicitly.
The current function only creates directories, not files, so `overwrite=TRUE` is safe to use on any existing project.


```r
newProject <- function(name, path, dirs = c("code", "data", "docs", "plots", 
    "workspaces"), docs.dirs = c("diagrams", "ioslides", "notebook", "pdf", 
    "Rmd/include", "timeline", "tufte"), overwrite = FALSE) {
    
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

#### rmdHeader
`rmdHeader` generates the yaml metadata header for Rmd files as a character string to be inserted at the top of a file.
It has default arguments specific to my own projects but can be changed.
The output from this function is passed directly to `genRmd` below.


```r
rmdHeader <- function(title = "INSERT_TITLE_HERE", author = "Matthew Leonawicz", 
    theme = "cosmo", highlight = "zenburn", toc = TRUE, keep.md = TRUE, ioslides = FALSE, 
    include.pdf = FALSE) {
    if (toc) 
        toc <= "true" else toc <- "false"
    if (keep.md) 
        keep.md <= "true" else keep.md <- "false"
    if (ioslides) 
        hdoc <- "ioslides_presentation" else hdoc <- "html_document"
    rmd.header <- paste0("---\ntitle: ", title, "\nauthor: ", author, "\noutput:\n  ", 
        hdoc, ":\n    toc: ", toc, "\n    theme: ", theme, "\n    highlight: ", 
        highlight, "\n    keep_md: ", keep.md, "\n")
    if (ioslides) 
        rmd.header <- paste0(rmd.header, "    widescreen: true\n")
    if (include.pdf) 
        rmd.header <- paste0(rmd.header, "  pdf_document:\n    toc: ", toc, 
            "\n    highlight: ", highlight, "\n")
    rmd.header <- paste0(rmd.header, "---\n")
    rmd.header
}
```

#### genRmd
`genRmd` works on existing projects. It checks for existing **R** scripts.
If no **R** files exist in the project's `code` directory, the function will abort.
Otherwise it will generate Rmd template files for each of the **R** scripts it finds.

With `replace=TRUE` any existing Rmd files are regenerated with the provided template - be careful!
With `replace=FALSE` (default) Rmd files are generated only for **R** scripts which do not yet have corresponding Rmd files.
If `update.header=TRUE`, `replace` is ignored, and only existing Rmd files are regenerated,
in this case strictly updating the yaml metadata header at the top of each Rmd file without altering any other Rmd content/documentation. 

The Rmd files are placed in the `/docs/Rmd` directory.
This function assumes this project directory exists.


```r
genRmd <- function(path, replace = FALSE, header = rmdHeader(), update.header = FALSE, 
    ...) {
    stopifnot(is.character(path))
    files <- list.files(path, pattern = ".R$", full = TRUE)
    stopifnot(length(files) > 0)
    rmd <- gsub(".R", ".Rmd", basename(files))
    rmd <- file.path(dirname(path), "docs/Rmd", rmd)
    if (!(replace | update.header)) 
        rmd <- rmd[!sapply(rmd, file.exists)]
    if (update.header) 
        rmd <- rmd[sapply(rmd, file.exists)]
    stopifnot(length(rmd) > 0)
    
    sinkRmd <- function(x, ...) {
        y1 <- header
        y2 <- list(...)$rmd.knitr.setup
        y3 <- list(...)$rmd.template
        if (is.null(y1)) 
            y1 <- rmd.header
        if (is.null(y2)) 
            y2 <- rmd.knitr.setup
        if (is.null(y3)) 
            y3 <- rmd.template
        sink(x)
        sapply(c(y1, y2, y3), cat)
        sink()
    }
    
    swapHeader <- function(x) {
        l <- readLines(x)
        ind <- which(l == "---")
        l <- l[(ind[2] + 1):length(l)]
        l <- paste0(l, "\n")
        sink(x)
        sapply(c(header, l), cat)
        sink()
    }
    
    if (update.header) {
        sapply(rmd, swapHeader, ...)
        cat("yaml header updated for each .Rmd file.\n")
    } else {
        sapply(rmd, sinkRmd, ...)
        cat(".Rmd files created for each .R file.\n")
    }
}
```

#### chunkNames
`chunkNames` can be used in two ways.
It can return a list with length equal to the number of **R** files,
where each list element is a vector of **R** code chunk names found in each **R** script.

Alternatively, with `append.new=TRUE`, this list has each vector matched element-wise against chunk names found in existing Rmd files.
If no Rmd files have yet been generated, the function will abort.
Otherwise, for the Rmd files which do exist (and this may correspond to a subset of the **R** files),
these Rmd files are appended with a list of code chunk names found in the current corresponding **R** files
which have not yet been integrated into the current state of the Rmd files.
This fascilitates updating of Rmd documentation when it falls behind scripts which have been updated.


```r
chunkNames <- function(path, rChunkID = "# @knitr", rmdChunkID = "```{r", append.new = FALSE) {
    files <- list.files(path, pattern = ".R$", full = TRUE)
    stopifnot(length(files) > 0)
    l1 <- lapply(files, readLines)
    l1 <- rapply(l1, function(x) x[substr(x, 1, nchar(rChunkID)) == rChunkID], 
        how = "replace")
    l1 <- rapply(l1, function(x, p) gsub(paste0(p, " "), "", x), how = "replace", 
        p = rChunkID)
    if (!append.new) 
        return(l1)
    
    appendRmd <- function(x, rmd.files, rChunks, rmdChunks, ID) {
        r1 <- rmdChunks[[x]]
        r2 <- rChunks[[x]]
        r.new <- r2[!(r2 %in% r1)]
        if (length(r.new)) {
            r.new <- paste0(ID, " ", r.new, "}\n```\n", collapse = "")  # Hard coded brace and backticks
            sink(rmd.files[x], append = TRUE)
            cat("\nNEW_CODE_CHUNKS\n")
            cat(r.new)
            sink()
            paste(basename(rmd.files[x]), "appended with new chunk names from .R file")
        } else paste("No new chunk names appended to", basename(rmd.files[x]))
    }
    
    rmd <- gsub(".R", ".Rmd", basename(files))
    rmd <- file.path(dirname(path), "docs/Rmd", rmd)
    rmd <- rmd[sapply(rmd, file.exists)]
    stopifnot(length(rmd) > 0)  # Rmd files must exist
    files.ind <- match(gsub(".Rmd", "", basename(rmd)), gsub(".R", "", basename(files)))  # Rmd exist for which R script
    l2 <- lapply(rmd, readLines)
    l2 <- rapply(l2, function(x) x[substr(x, 1, nchar(rmdChunkID)) == rmdChunkID], 
        how = "replace")
    l2 <- rapply(l2, function(x, p) gsub(paste0(p, " "), "", x), how = "replace", 
        p = gsub("\\{", "\\\\{", rmdChunkID))
    l2 <- rapply(l2, function(x) gsub("}", "", sapply(strsplit(x, ","), "[[", 
        1)), how = "replace")
    sapply(1:length(rmd), appendRmd, rmd.files = rmd, rChunks = l1[files.ind], 
        rmdChunks = l2, ID = rmdChunkID)
}
```

Regarding the creation and updating of Rmd files, `projman` simply assumes that there will be one **R** Markdown file corresponding to one **R** script.
This is not always the case for a given project, but again, the purpose is to generate basic templates.
Unnecessary files can always be deleted later, or edits made such that one **R** Markdown file reads multiple **R** scripts,
as is the case with the Rmd file used to generate this document.

#### genNavbar

`genNavbar` generates a navigation bar for a web page.
The html file created should be written to the project's `docs/Rmd/include` directory.
The common navigation bar html is included prior to the body of the html for each web page in the project's website.
`menu` is a vector of names for each dropdown menu.
`submenus` is a list of vectors of menu options corresponding to each menu.
`files` is a similar list of vectors.
Each element is either an html file for a web page to be associated with the submenu link,
"header" to indicate the corresponding name in `submenus` is only a group label and not a link to a web page,
or "divider" to indicate placement of a bar for separating groups in a dropdown menu.


```r
genNavbar <- function(htmlfile = "navbar.html", title, menu, submenus, files, 
    site.link = "", site.name = "Website") {
    
    fillSubmenu <- function(x, name, file) {
        if (file[x] == "divider") 
            return("              <li class=\"divider\"></li>\n")
        if (file[x] == "header") 
            return(paste0("              <li class=\"nav-header\">", name[x], 
                "</li>\n"))
        paste0("              <li><a href=\"", file[x], "\">", name[x], "</a></li>\n")
    }
    
    fillMenu <- function(x, menu, submenus, files) {
        paste0("<li class=\"dropdown\">\n            <a href=\"", gsub(" ", 
            "-", tolower(menu[x])), "\" class=\"dropdown-toggle\" data-toggle=\"dropdown\">", 
            menu[x], " <b class=\"caret\"></b></a>\n            <ul class=\"dropdown-menu\">\n", 
            paste(sapply(1:length(submenus[[x]]), fillSubmenu, name = submenus[[x]], 
                file = files[[x]]), sep = "", collapse = ""), "            </ul>\n", 
            collapse = "")
    }
    
    x <- paste0("<div class=\"navbar navbar-default navbar-fixed-top\">\n  <div class=\"navbar-inner\">\n    <div class=\"container\">\n      <button type=\"button\" class=\"btn btn-navbar\" data-toggle=\"collapse\" data-target=\".nav-collapse\">\n        <span class=\"icon-bar\"></span>\n        <span class=\"icon-bar\"></span>\n        <span class=\"icon-bar\"></span>\n      </button>\n      <a class=\"brand\" href=\"/\">", 
        title, "</a>\n      <div class=\"nav-collapse collapse\">\n        <ul class=\"nav\">\n          <li><a href=\"/\">Home</a></li>\n          ", 
        paste(sapply(1:length(menu), fillMenu, menu = menu, submenus = submenus, 
            files = files), sep = "", collapse = "\n          "), "        </ul>\n        <ul class=\"nav pull-right\">\n          <a class=\"btn btn-primary\" href=\"", 
        site.link, "\">\n            <i class=\"fa fa-github fa-lg\"></i>\n            ", 
        site.name, "\n          </a>\n        </ul>\n      </div><!--/.nav-collapse -->\n    </div>\n  </div>\n</div>\n", 
        collpase = "")
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
        output.yaml <- paste0(output.yaml, "    in_header: include/", header, 
            "\n")
    if (!is.null(before_body)) 
        output.yaml <- paste0(output.yaml, "    before_body: include/", before_body, 
            "\n")
    if (!is.null(after_body)) 
        output.yaml <- paste0(output.yaml, "    after_body: include/", after_body, 
            "\n")
    sink(file)
    cat(output.yaml)
    sink()
    output.yaml
}
```

