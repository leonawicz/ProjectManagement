# Matt's Projects
Matthew Leonawicz  




## Introduction
I have begun using a Sankey diagram to illustrate various types of connections among my projects.
Here the purpose is to show the code used to create the project hierarchy graph shows elsewhere (and below).

### Motivation
I have created this diagram showing project and collaborator relationships that occur in my current work as part of this `rpm` Project Management Project.
However, this is a special case shown here.
In general, the reason for folding this type of graph into all of my individual projects as part of project management
is to show code and data relationships that exist for a specific project.
For example, `rpm` has its own code flow diagram as do my other projects.
But here the focus is on the particular project hierarchy diagram that is part of this project.

## Project hierarchy **R** code
Here is the code used to generate the current project hierarchy diagram.
Two packages are required.


```r
require(igraph)
require(rCharts)
```

Current projects are hardcoded and are updated by hand when my work changes. A necessary evil.
This is essentially the data, consisting of both projects and collaborators.


```r
proj.mp <- c("Alfresco Noatak", "Alfresco Statewide", "Spatial Lightning Analysis", 
    "Data Extraction and Uncertainty Analysis", "Growing Season", "Mussel Project", 
    "Land Carbon")
proj.etal <- c("Alfresco CRU/GCM Experimental Design", "Bird Project", "NWT/Comm. Charts DS", 
    "Sea Ice Edge Maps and Spinoff Projects", "Shiny App Server Migration")
proj.m <- c("CMIP3/CMIP5 GCM Comparisons", "Effective Spatial Scale Analysis", 
    "Randscape Development", "Alfresco Outputs", "rpm")
proj.ongoing <- c("SNAP Data QA/QC", "Training/Supervision", "R Shiny Apps General Maintenance", 
    "New App Development", "SNAP Tech Blog", "Continuing Education")
proj.halted <- c("FRP/FRI Scale-Conditional Alfresco Maps", "Moose Project")
projects.list <- list(proj.mp, proj.etal, proj.m, proj.ongoing, proj.halted)
```


```r
actors.etal <- list(c("Paul", "Alec"), "Angie", c("Angie", "Bob"), "Angie", 
    "Bob")
actors.all <- unique(c("Matt", "Paul", unlist(actors.etal)))
```

Directional connections must be made among project and among people and projects.
The connections are expressed by element-wise comparison of the equal-length `to` and `from` vectors.


```r
from <- c(
	# LHS
	rep("Collaborators", length(actors.all[actors.all!="Matt"])),
	rep("Matt", length(c(proj.m, proj.ongoing, proj.halted))),
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
	actors.all[actors.all!="Matt"],
	proj.m,
	proj.ongoing,
	proj.halted,
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
```

The vectors are combined in a data frame and the `igraph` package is used to grow the tree diagram.


```r
relations <- data.frame(from = from, to = to)
g <- graph.data.frame(relations, directed = T, vertices = data.frame(c("Collaborators", 
    actors.all, unlist(projects.list))))

gw <- get.data.frame(g)
gw$value <- 1
colnames(gw) <- c("source", "target", "value")
gw$source <- as.character(gw$source)
gw$target <- as.character(gw$target)
```

The `rcharts` package has functionality for turning this into an interactive D3 visualization,
which is nice, particularly the mouseover interactivity, since there can be so much visual overlap among projects.
Additional javascript can be included to alter the colors.
My strengths are in **R** so I borrowed this code snippet from online,
but if you have skills with javascript and D3 you could probably do better with color control and opacity I imagine.


```r
p <- rCharts$new()
p$setLib("http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey")
p$setTemplate(script = "http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey/layouts/chart.html")
p$set(data = gw, nodeWidth = 15, nodePadding = 10, layout = 32, width = 900, 
    height = 800, margin = list(right = 20, left = 20, bottom = 20, top = 20), 
    title = "Matt's Projects")

p$setTemplate(afterScript = "\n<script>\n  var cscale = d3.scale.category20b();\n  d3.selectAll('#{{ chartId }} svg path.link')\n    .style('stroke', function(d){\n      return cscale(d.source.name);\n    })\n  d3.selectAll('#{{ chartId }} svg .node rect')\n    .style('fill', function(d){\n      return cscale(d.name)\n    })\n    .style('stroke', 'none')\n</script>\n")
```

Embed the chart in a document when rendering.


```r
p$show("iframesrc", cdn=T)
```

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
    
    &lt;div id = &#039;chart8bc6d931f5a&#039; class = &#039;rChart d3_sankey&#039;&gt;&lt;/div&gt;    
    ï»¿&lt;!--Attribution:
Mike Bostock https://github.com/d3/d3-plugins/tree/master/sankey
Mike Bostock http://bost.ocks.org/mike/sankey/
--&gt;

&lt;script&gt;
(function(){
var params = {
 &quot;dom&quot;: &quot;chart8bc6d931f5a&quot;,
&quot;width&quot;:    900,
&quot;height&quot;:    800,
&quot;data&quot;: {
 &quot;source&quot;: [ &quot;Collaborators&quot;, &quot;Collaborators&quot;, &quot;Collaborators&quot;, &quot;Collaborators&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Matt&quot;, &quot;Paul&quot;, &quot;Alec&quot;, &quot;Angie&quot;, &quot;Angie&quot;, &quot;Bob&quot;, &quot;Angie&quot;, &quot;Bob&quot;, &quot;Alfresco Outputs&quot;, &quot;Alfresco Outputs&quot;, &quot;Alfresco Outputs&quot;, &quot;SNAP Data QA/QC&quot;, &quot;SNAP Data QA/QC&quot;, &quot;SNAP Data QA/QC&quot;, &quot;SNAP Data QA/QC&quot;, &quot;Spatial Lightning Analysis&quot;, &quot;Spatial Lightning Analysis&quot;, &quot;Spatial Lightning Analysis&quot;, &quot;Sea Ice Edge Maps and Spinoff Projects&quot;, &quot;Sea Ice Edge Maps and Spinoff Projects&quot;, &quot;Training/Supervision&quot;, &quot;Training/Supervision&quot;, &quot;Randscape Development&quot;, &quot;Randscape Development&quot;, &quot;Effective Spatial Scale Analysis&quot;, &quot;Effective Spatial Scale Analysis&quot;, &quot;NWT/Comm. Charts DS&quot;, &quot;Alfresco Noatak&quot;, &quot;Alfresco Statewide&quot;, &quot;Data Extraction and Uncertainty Analysis&quot;, &quot;Data Extraction and Uncertainty Analysis&quot;, &quot;Data Extraction and Uncertainty Analysis&quot;, &quot;Data Extraction and Uncertainty Analysis&quot; ],
&quot;target&quot;: [ &quot;Paul&quot;, &quot;Alec&quot;, &quot;Angie&quot;, &quot;Bob&quot;, &quot;CMIP3/CMIP5 GCM Comparisons&quot;, &quot;Effective Spatial Scale Analysis&quot;, &quot;Randscape Development&quot;, &quot;Alfresco Outputs&quot;, &quot;rpm&quot;, &quot;SNAP Data QA/QC&quot;, &quot;Training/Supervision&quot;, &quot;R Shiny Apps General Maintenance&quot;, &quot;New App Development&quot;, &quot;SNAP Tech Blog&quot;, &quot;Continuing Education&quot;, &quot;FRP/FRI Scale-Conditional Alfresco Maps&quot;, &quot;Moose Project&quot;, &quot;Alfresco Noatak&quot;, &quot;Alfresco Statewide&quot;, &quot;Spatial Lightning Analysis&quot;, &quot;Data Extraction and Uncertainty Analysis&quot;, &quot;Growing Season&quot;, &quot;Mussel Project&quot;, &quot;Land Carbon&quot;, &quot;Alfresco Noatak&quot;, &quot;Alfresco Statewide&quot;, &quot;Spatial Lightning Analysis&quot;, &quot;Data Extraction and Uncertainty Analysis&quot;, &quot;Growing Season&quot;, &quot;Mussel Project&quot;, &quot;Land Carbon&quot;, &quot;Alfresco CRU/GCM Experimental Design&quot;, &quot;Bird Project&quot;, &quot;NWT/Comm. Charts DS&quot;, &quot;Sea Ice Edge Maps and Spinoff Projects&quot;, &quot;Shiny App Server Migration&quot;, &quot;Alfresco CRU/GCM Experimental Design&quot;, &quot;Alfresco CRU/GCM Experimental Design&quot;, &quot;Bird Project&quot;, &quot;NWT/Comm. Charts DS&quot;, &quot;NWT/Comm. Charts DS&quot;, &quot;Sea Ice Edge Maps and Spinoff Projects&quot;, &quot;Shiny App Server Migration&quot;, &quot;CMIP3/CMIP5 GCM Comparisons&quot;, &quot;Land Carbon&quot;, &quot;Bird Project&quot;, &quot;Alfresco Outputs&quot;, &quot;CMIP3/CMIP5 GCM Comparisons&quot;, &quot;Alfresco CRU/GCM Experimental Design&quot;, &quot;NWT/Comm. Charts DS&quot;, &quot;Alfresco Noatak&quot;, &quot;Alfresco Statewide&quot;, &quot;Randscape Development&quot;, &quot;Randscape Development&quot;, &quot;Alfresco Outputs&quot;, &quot;Bird Project&quot;, &quot;NWT/Comm. Charts DS&quot;, &quot;Alfresco Outputs&quot;, &quot;Effective Spatial Scale Analysis&quot;, &quot;Alfresco Outputs&quot;, &quot;FRP/FRI Scale-Conditional Alfresco Maps&quot;, &quot;CMIP3/CMIP5 GCM Comparisons&quot;, &quot;FRP/FRI Scale-Conditional Alfresco Maps&quot;, &quot;FRP/FRI Scale-Conditional Alfresco Maps&quot;, &quot;CMIP3/CMIP5 GCM Comparisons&quot;, &quot;Effective Spatial Scale Analysis&quot;, &quot;Randscape Development&quot;, &quot;Alfresco Outputs&quot; ],
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
&quot;id&quot;: &quot;chart8bc6d931f5a&quot; 
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
      d3.selectAll(&#039;#chart8bc6d931f5a svg path.link&#039;)
        .style(&#039;stroke&#039;, function(d){
          return cscale(d.source.name);
        })
      d3.selectAll(&#039;#chart8bc6d931f5a svg .node rect&#039;)
        .style(&#039;fill&#039;, function(d){
          return cscale(d.name)
        })
        .style(&#039;stroke&#039;, &#039;none&#039;)
    &lt;/script&gt;
        
  &lt;/body&gt;
&lt;/html&gt; ' scrolling='no' frameBorder='0' seamless class='rChart  http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey  ' id='iframe-chart8bc6d931f5a'> </iframe>
 <style>iframe.rChart{ width: 100%; height: 400px;}</style>
<style>iframe.rChart{ width: 100%; height: 840px;}</style>

