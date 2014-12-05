# @knitr sankey
require(igraph)
require(rCharts)

proj.mp <- c("Alfresco Noatak", "Alfresco Statewide", "Spatial Lightning Analysis", "Data Extraction and Uncertainty Analysis", "Growing Season", "Mussel Project", "Land Carbon")
proj.etal <- c("Alfresco CRU/GCM Experimental Design", "Bird Project", "NWT/Comm. Charts DS", "Sea Ice Edge Maps and Spinoff Projects", "Shiny App Server Migration")
proj.m <- c("CMIP3/CMIP5 GCM Comparisons", "Effective Spatial Scale Analysis", "Randscape Development", "Alfresco Outputs", "Projman")
proj.ongoing <- c("SNAP Data QA/QC", "Training/Supervision", "R Shiny Apps General Maintenance", "New App Development", "SNAP Tech Blog", "Continuing Education")
proj.halted <- c("FRP/FRI Scale-Conditional Alfresco Maps", "Moose Project")
projects.list <-list(proj.mp, proj.etal, proj.m, proj.ongoing, proj.halted)

actors.etal <- list(c("Paul", "Alec"), "Angie", c("Angie", "Bob"), "Angie", "Bob")
actors.all <- unique(c("Matt", "Paul", unlist(actors.etal)))
status.colors <- rep(c("green", "blue", "orange", "purple", "red"), times=sapply(projects.list, length))
status.colors <- rep(c("green", "blue", "orange", "purple", "red"), times=sapply(projects.list, length))

from <- c(
	# LHS
	rep("Collaborators", length(actors.all[actors.all!="Matt"])),
	rep("Matt", length(c(proj.m, proj.ongoing, proj.halted))),
	# Middle
	rep(c("Matt", "Paul"), length(proj.mp)),
	rep("Matt", length(proj.etal)),
	unlist(actors.etal),
	# Specific connections
	rep("Alfresco Outputs", 3),
	rep("SNAP Data QA/QC", 4),
	rep("Spatial Lightning Analysis", 3),
	rep("Sea Ice Edge Maps and Spinoff Projects", 2),
	rep("Training/Supervision", 2),
	rep("Randscape Development", 2),
	rep("Effective Spatial Scale Analysis", 2),
	rep("NWT/Comm. Charts DS", 1),
	c("Alfresco Noatak", "Alfresco Statewide"),
	rep("Data Extraction and Uncertainty Analysis", 4)
	
)
to <- c(
	# Middle
	actors.all[actors.all!="Matt"],
	proj.m,
	proj.ongoing,
	proj.halted,
	# RHS
	rep(proj.mp, 2),
	proj.etal,
	rep(proj.etal, times=sapply(actors.etal, length)),
	# Specific connections
	c("CMIP3/CMIP5 GCM Comparisons", "Land Carbon", "Bird Project"), # from "Alfresco Outputs"
	c("Alfresco Outputs", "CMIP3/CMIP5 GCM Comparisons", "Alfresco CRU/GCM Experimental Design", "NWT/Comm. Charts DS"), # from "SNAP Data QA/QC"
	c("Alfresco Noatak", "Alfresco Statewide", "Randscape Development"), # from "Spatial Lightning Analysis
	c("Randscape Development", "Alfresco Outputs"), # from "Sea Ice Edge Maps and Spinoff Projects"
	c("Bird Project", "NWT/Comm. Charts DS"), # from "Training/Supervision"
	c("Alfresco Outputs", "Effective Spatial Scale Analysis"), # from "Randscape Development
	c("Alfresco Outputs", "FRP/FRI Scale-Conditional Alfresco Maps"), # from "Effective Spatial Scale Analysis"
	c("CMIP3/CMIP5 GCM Comparisons"), #from "NWT/Comm. Charts DS"
	rep("FRP/FRI Scale-Conditional Alfresco Maps", 2), # from "Alfresco Noatak", "Alfresco Statewide"
	c("CMIP3/CMIP5 GCM Comparisons", "Effective Spatial Scale Analysis", "Randscape Development", "Alfresco Outputs") # from "Data Extraction and Uncertainty Analysis"
)
relations <- data.frame(from=from, to=to)
g <- graph.data.frame(relations, directed=T, vertices=data.frame(c("Collaborators", actors.all, unlist(projects.list))))

#V(g)$weight = 0
#V(g)[degree(g,mode="out")==0]$weight <- runif(n=length(V(g)[degree(g,mode="out")==0]),min=0,max=100)
#E(g)[to(V(g)$weight>0)]$weight <- V(g)[V(g)$weight>0]$weight
#while(max(is.na(E(g)$weight))) {
#	df <- get.data.frame(g)
#	for (i in 1:nrow(df)) {
#		x = df[i,]
#		if(max(df$from==x$to)) {
#			E(g)[from(x$from) & to(x$to)]$weight = sum(E(g)[from(x$to)]$weight)
#		}
#	}
#}
gw <- get.data.frame(g)
gw$value <- 1
colnames(gw) <- c("source","target","value")
gw$source <- as.character(gw$source)
gw$target <- as.character(gw$target)
p <- rCharts$new()
p$setLib('http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey')
p$setTemplate(script = "http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey/layouts/chart.html")
p$set(
data = gw,
nodeWidth = 15,
nodePadding = 10,
layout = 32,
width = 900,
height = 800,
margin = list(right = 20, left = 20, bottom = 20, top = 20),
title = "Matt's Projects"
)

p$setTemplate(
  afterScript = "
<script>
  var cscale = d3.scale.category20b();

  // to be specific in case you have more than one chart
  d3.selectAll('#{{ chartId }} svg path.link')
    .style('stroke', function(d){
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
   // .style('stroke-opacity', .7)
  d3.selectAll('#{{ chartId }} svg .node rect')
    .style('fill', function(d){
      return cscale(d.name)
    })
    .style('stroke', 'none')
</script>
")

# @knitr sankey_save
out <- "X:/Leonawicz/Projects/2014/ProjectManagement/docs/all/project_hierarchy.html"
p$save(out)

# @knitr sankey_embed
p$show("iframesrc", cdn=T)
