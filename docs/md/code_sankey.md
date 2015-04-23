# Project Management
Matthew Leonawicz  

## Related items
Currently there is only this unpackaged **R** script, accompanying code for a projects hierarchy diagram
and a code flow diagram based on the current development of this project, and a simple script for generating documents based on project **R** code.

### Files and Data
This project does not use any data.
It does make use of supplemental libraries for formatting during html document generation.
`proj_sankey.R` and `code_sankey.R` are used to produce of project hierarchy diagram of my current projects and a code flow diagram for this project, respectively.
`pm.R` is used to assist in dynamic report generation by way of `rpm`.
Each project has a `pm.R` script.

### Code flow
The Sankey diagram has become part of my project management.
Each project has its own, detailing the relationships among **R** code and data relevant to the project,
and in some cases, how they relate to code and data files which are more general and span multiple projects.
In general, for my projects I would only provide the code flow diagram here among the rest of the project documentation,
but since this is the project management project and I am introducing its use,
in this case I will also show the code I use to make the diagram.



## **R** code
Here is the code used to generate the code flow diagram.

### Initial setup

Two packages are required.


```r
require(igraph)
require(rCharts)
```

Project file names can be loaded using `pattern` arguments with `list.files` pointing to both the `code` and relevant `docs` directories.
However, there is a substantial amount of hardcoding involved for any project as shown here.
For example, the `rpm.R` script contains all the `rpm` functions. 
Although this script has a complete, corresponding `rpm.Rmd` file, I decided to subsequently break out the functions and other content from `rpm.Rmd` into multiple Rmd files.
Such ad hoc project-specific decisions require that I take note here and make the related distinctions.


```r
setwd("C:/github/ProjectManagement/docs/Rmd")

c0 <- list.files("../../code", pattern = ".R$")
c1a <- c("_output.yaml", "navbar.html", "leonawicz.github.io")
c1b <- "supporting libraries"
c1c <- "in_header.html"

c2 <- list.files(pattern = ".Rmd$")
rmd.primary <- which(gsub(".Rmd", ".R", c2) %in% c0)
c2a <- c2[rmd.primary]
c2b <- c2[-rmd.primary]

c3 <- gsub(".Rmd", ".md", c2)
c4 <- gsub(".Rmd", ".html", c2)
```

Directional connections must be made among files.
The connections are expressed by element-wise comparison of the equal-length `to` and `from` vectors.


```r
from <- c(
	c0,	rep("rpm.Rmd", length(c2b)), c2, c2, rep("pm.R", length(c1a)), c1b, rep(c(c1a, c1c), each=length(c4))

)
to <- c(
	c2a, c2b, c3, c4, c1a, "pm.R", rep(c4, length(c(c1a, c1c)))
)
```

### Create a directional tree graph

The vectors are combined in a data frame and the `igraph` package is used to grow the tree diagram.


```r
relations <- data.frame(from = from, to = to)
g <- graph.data.frame(relations, directed = T, vertices = data.frame(c(c0, c1a, 
    c1b, c1c, c2, c3, c4)))

gw <- get.data.frame(g)
gw$value <- 1
colnames(gw) <- c("source", "target", "value")
gw$source <- as.character(gw$source)
gw$target <- as.character(gw$target)
```

### Display with rCharts

The `rcharts` package has functionality for turning this into an interactive D3 visualization,
which is nice, particularly the mouseover interactivity, since there can be so much visual overlap among files for complex projects.
Additional javascript can be included to alter the colors.
My strengths are in **R** so I borrowed this code snippet from online,
but if you have skills with javascript and D3 you could probably do better with color control and opacity I imagine.


```r
p <- rCharts$new()
p$setLib("http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey")
p$setTemplate(script = "http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey/layouts/chart.html")
p$set(data = gw, nodeWidth = 15, nodePadding = 10, layout = 32, width = 900, 
    height = 800, margin = list(right = 20, left = 20, bottom = 50, top = 50), 
    title = "Code Flow")

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
    
    &lt;div id = &#039;chart8bc78f075ac&#039; class = &#039;rChart d3_sankey&#039;&gt;&lt;/div&gt;    
    ï»¿&lt;!--Attribution:
Mike Bostock https://github.com/d3/d3-plugins/tree/master/sankey
Mike Bostock http://bost.ocks.org/mike/sankey/
--&gt;

&lt;script&gt;
(function(){
var params = {
 &quot;dom&quot;: &quot;chart8bc78f075ac&quot;,
&quot;width&quot;:    900,
&quot;height&quot;:    800,
&quot;data&quot;: {
 &quot;source&quot;: [ &quot;code_sankey.R&quot;, &quot;pm.R&quot;, &quot;proj_sankey.R&quot;, &quot;rpm.R&quot;, &quot;rpm.Rmd&quot;, &quot;rpm.Rmd&quot;, &quot;rpm.Rmd&quot;, &quot;rpm.Rmd&quot;, &quot;rpm.Rmd&quot;, &quot;rpm.Rmd&quot;, &quot;rpm.Rmd&quot;, &quot;rpm.Rmd&quot;, &quot;rpm.Rmd&quot;, &quot;code_sankey.Rmd&quot;, &quot;func_convert.Rmd&quot;, &quot;func_new.Rmd&quot;, &quot;func_organize.Rmd&quot;, &quot;func_rmd.Rmd&quot;, &quot;func_stats.Rmd&quot;, &quot;func_user_website.Rmd&quot;, &quot;func_website.Rmd&quot;, &quot;index.Rmd&quot;, &quot;objects.Rmd&quot;, &quot;pm.Rmd&quot;, &quot;proj_sankey.Rmd&quot;, &quot;rpm.Rmd&quot;, &quot;code_sankey.Rmd&quot;, &quot;func_convert.Rmd&quot;, &quot;func_new.Rmd&quot;, &quot;func_organize.Rmd&quot;, &quot;func_rmd.Rmd&quot;, &quot;func_stats.Rmd&quot;, &quot;func_user_website.Rmd&quot;, &quot;func_website.Rmd&quot;, &quot;index.Rmd&quot;, &quot;objects.Rmd&quot;, &quot;pm.Rmd&quot;, &quot;proj_sankey.Rmd&quot;, &quot;rpm.Rmd&quot;, &quot;pm.R&quot;, &quot;pm.R&quot;, &quot;pm.R&quot;, &quot;supporting libraries&quot;, &quot;_output.yaml&quot;, &quot;_output.yaml&quot;, &quot;_output.yaml&quot;, &quot;_output.yaml&quot;, &quot;_output.yaml&quot;, &quot;_output.yaml&quot;, &quot;_output.yaml&quot;, &quot;_output.yaml&quot;, &quot;_output.yaml&quot;, &quot;_output.yaml&quot;, &quot;_output.yaml&quot;, &quot;_output.yaml&quot;, &quot;_output.yaml&quot;, &quot;navbar.html&quot;, &quot;navbar.html&quot;, &quot;navbar.html&quot;, &quot;navbar.html&quot;, &quot;navbar.html&quot;, &quot;navbar.html&quot;, &quot;navbar.html&quot;, &quot;navbar.html&quot;, &quot;navbar.html&quot;, &quot;navbar.html&quot;, &quot;navbar.html&quot;, &quot;navbar.html&quot;, &quot;navbar.html&quot;, &quot;leonawicz.github.io&quot;, &quot;leonawicz.github.io&quot;, &quot;leonawicz.github.io&quot;, &quot;leonawicz.github.io&quot;, &quot;leonawicz.github.io&quot;, &quot;leonawicz.github.io&quot;, &quot;leonawicz.github.io&quot;, &quot;leonawicz.github.io&quot;, &quot;leonawicz.github.io&quot;, &quot;leonawicz.github.io&quot;, &quot;leonawicz.github.io&quot;, &quot;leonawicz.github.io&quot;, &quot;leonawicz.github.io&quot;, &quot;in_header.html&quot;, &quot;in_header.html&quot;, &quot;in_header.html&quot;, &quot;in_header.html&quot;, &quot;in_header.html&quot;, &quot;in_header.html&quot;, &quot;in_header.html&quot;, &quot;in_header.html&quot;, &quot;in_header.html&quot;, &quot;in_header.html&quot;, &quot;in_header.html&quot;, &quot;in_header.html&quot;, &quot;in_header.html&quot; ],
&quot;target&quot;: [ &quot;code_sankey.Rmd&quot;, &quot;pm.Rmd&quot;, &quot;proj_sankey.Rmd&quot;, &quot;rpm.Rmd&quot;, &quot;func_convert.Rmd&quot;, &quot;func_new.Rmd&quot;, &quot;func_organize.Rmd&quot;, &quot;func_rmd.Rmd&quot;, &quot;func_stats.Rmd&quot;, &quot;func_user_website.Rmd&quot;, &quot;func_website.Rmd&quot;, &quot;index.Rmd&quot;, &quot;objects.Rmd&quot;, &quot;code_sankey.md&quot;, &quot;func_convert.md&quot;, &quot;func_new.md&quot;, &quot;func_organize.md&quot;, &quot;func_rmd.md&quot;, &quot;func_stats.md&quot;, &quot;func_user_website.md&quot;, &quot;func_website.md&quot;, &quot;index.md&quot;, &quot;objects.md&quot;, &quot;pm.md&quot;, &quot;proj_sankey.md&quot;, &quot;rpm.md&quot;, &quot;code_sankey.html&quot;, &quot;func_convert.html&quot;, &quot;func_new.html&quot;, &quot;func_organize.html&quot;, &quot;func_rmd.html&quot;, &quot;func_stats.html&quot;, &quot;func_user_website.html&quot;, &quot;func_website.html&quot;, &quot;index.html&quot;, &quot;objects.html&quot;, &quot;pm.html&quot;, &quot;proj_sankey.html&quot;, &quot;rpm.html&quot;, &quot;_output.yaml&quot;, &quot;navbar.html&quot;, &quot;leonawicz.github.io&quot;, &quot;pm.R&quot;, &quot;code_sankey.html&quot;, &quot;func_convert.html&quot;, &quot;func_new.html&quot;, &quot;func_organize.html&quot;, &quot;func_rmd.html&quot;, &quot;func_stats.html&quot;, &quot;func_user_website.html&quot;, &quot;func_website.html&quot;, &quot;index.html&quot;, &quot;objects.html&quot;, &quot;pm.html&quot;, &quot;proj_sankey.html&quot;, &quot;rpm.html&quot;, &quot;code_sankey.html&quot;, &quot;func_convert.html&quot;, &quot;func_new.html&quot;, &quot;func_organize.html&quot;, &quot;func_rmd.html&quot;, &quot;func_stats.html&quot;, &quot;func_user_website.html&quot;, &quot;func_website.html&quot;, &quot;index.html&quot;, &quot;objects.html&quot;, &quot;pm.html&quot;, &quot;proj_sankey.html&quot;, &quot;rpm.html&quot;, &quot;code_sankey.html&quot;, &quot;func_convert.html&quot;, &quot;func_new.html&quot;, &quot;func_organize.html&quot;, &quot;func_rmd.html&quot;, &quot;func_stats.html&quot;, &quot;func_user_website.html&quot;, &quot;func_website.html&quot;, &quot;index.html&quot;, &quot;objects.html&quot;, &quot;pm.html&quot;, &quot;proj_sankey.html&quot;, &quot;rpm.html&quot;, &quot;code_sankey.html&quot;, &quot;func_convert.html&quot;, &quot;func_new.html&quot;, &quot;func_organize.html&quot;, &quot;func_rmd.html&quot;, &quot;func_stats.html&quot;, &quot;func_user_website.html&quot;, &quot;func_website.html&quot;, &quot;index.html&quot;, &quot;objects.html&quot;, &quot;pm.html&quot;, &quot;proj_sankey.html&quot;, &quot;rpm.html&quot; ],
&quot;value&quot;: [      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1 ] 
},
&quot;nodeWidth&quot;:     15,
&quot;nodePadding&quot;:     10,
&quot;layout&quot;:     32,
&quot;margin&quot;: {
 &quot;right&quot;:     20,
&quot;left&quot;:     20,
&quot;bottom&quot;:     50,
&quot;top&quot;:     50 
},
&quot;title&quot;: &quot;Code Flow&quot;,
&quot;id&quot;: &quot;chart8bc78f075ac&quot; 
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
      d3.selectAll(&#039;#chart8bc78f075ac svg path.link&#039;)
        .style(&#039;stroke&#039;, function(d){
          return cscale(d.source.name);
        })
      d3.selectAll(&#039;#chart8bc78f075ac svg .node rect&#039;)
        .style(&#039;fill&#039;, function(d){
          return cscale(d.name)
        })
        .style(&#039;stroke&#039;, &#039;none&#039;)
    &lt;/script&gt;
        
  &lt;/body&gt;
&lt;/html&gt; ' scrolling='no' frameBorder='0' seamless class='rChart  http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey  ' id='iframe-chart8bc78f075ac'> </iframe>
 <style>iframe.rChart{ width: 100%; height: 400px;}</style>
<style>iframe.rChart{ width: 100%; height: 840px;}</style>

