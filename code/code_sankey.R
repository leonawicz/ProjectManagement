# @knitr sankey_packages
require(igraph)
require(rCharts)

# @knitr files
setwd("C:/github/ProjectManagement/docs/Rmd")

c0 <- list.files("../../code", pattern=".R$")
c1a <- c("_output.yaml", "navbar.html", "leonawicz.github.io")
c1b <- "supporting libraries"
c1c <- "in_header.html"

c2 <- list.files(pattern=".Rmd$")
rmd.primary <- which(gsub(".Rmd", ".R", c2) %in% c0)
c2a <- c2[rmd.primary]
c2b <- c2[-rmd.primary]

c3 <- gsub(".Rmd", ".md", c2)
c4 <- gsub(".Rmd", ".html", c2)

# @knitr links
from <- c(
	c0,	rep("rpm.Rmd", length(c2b)), c2, c2, rep("pm.R", length(c1a)), c1b, rep(c(c1a, c1c), each=length(c4))

)
to <- c(
	c2a, c2b, c3, c4, c1a, "pm.R", rep(c4, length(c(c1a, c1c)))
)

# @knitr igraph
relations <- data.frame(from=from, to=to)
g <- graph.data.frame(relations, directed=T, vertices=data.frame(c(c0, c1a, c1b, c1c, c2, c3, c4)))

gw <- get.data.frame(g)
gw$value <- 1
colnames(gw) <- c("source","target","value")
gw$source <- as.character(gw$source)
gw$target <- as.character(gw$target)

# @knitr rcharts
p <- rCharts$new()
p$setLib('http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey')
p$setTemplate(script = "http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey/layouts/chart.html")
p$set(data=gw, nodeWidth=15, nodePadding=10, layout=32, width=900, height=800, margin=list(right=20, left=20, bottom=50, top=50), title="Code Flow")

p$setTemplate(
  afterScript="
<script>
  var cscale = d3.scale.category20b();
  d3.selectAll('#{{ chartId }} svg path.link')
    .style('stroke', function(d){
      return cscale(d.source.name);
    })
  d3.selectAll('#{{ chartId }} svg .node rect')
    .style('fill', function(d){
      return cscale(d.name)
    })
    .style('stroke', 'none')
</script>
")

# @knitr sankey_save
out <- "C:/github/ProjectManagement/docs/html/codeflow.html"
p$save(out)

# @knitr sankey_embed
p$show("iframesrc", cdn=T)
