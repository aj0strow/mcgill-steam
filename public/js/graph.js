;(function() {
  // declare important variables (goddamn javascript)
  var GRAPH_ASPECT_RATIO, MARGIN, CIRCLE_RADIUS, graph, svg, width, height, iso, scale, axes, line, circle;      
      
  // set constants
  GRAPH_ASPECT_RATIO = 0.6;
  MARGIN = { top: 20, right: 20, bottom: 30, left: 50 };
  CIRCLE_RADIUS = 4;
      
  // iso formatting, use like iso.parse(dateString)
  iso = d3.time.format.utc("%Y-%m-%dT%H:%M:%SZ");
      
  // helpers
  function pluck(key, callback) {
    if (callback) {
      return function(d) { return callback(d[key]) };
    } else {
      return function(d) { return d[key] };
    }
  }
  
  // call back for data point hover
  function pointover(point) {    
    var el = d3.select(this)
      .transition().duration(100)
      .style('fill', 'black')
      .attr('r', 6);
    svg.append('text')
      .classed('figure', true)
      .text(point.steam + ' lbs/hr')
      .attr('x', width + 'px')
      .attr('y', '16px')
      .style('font-size', '26px')
      .attr('text-anchor', 'end');
  }
  
  // cleanup for data point hover
  function pointout(point) {
    d3.select(this)
      .transition().duration(100)
      .style('fill', 'steelblue')
      .attr('r', CIRCLE_RADIUS);
    d3.selectAll('text.figure').remove();
  }
      
  // select elements
  graph = d3.select('#graph');
      
  // protect scope and set dimensions
  (function() {
    var fullWidth = parseInt(graph.style('width'), 10) - 30;
    var fullHeight = Math.round(fullWidth * GRAPH_ASPECT_RATIO);
        
    // set svg area
    var translation = 'translate(' + MARGIN.left + ',' + MARGIN.top + ')';
    svg = graph.append('svg')
        .style('border', '1px solid #eee')
        .attr('width', fullWidth + 'px')
        .attr('height', fullHeight + 'px')
      .append("g")
        .attr('transform', translation);
        
    // save w & h of svg area
    width = fullWidth - MARGIN.left - MARGIN.right ;
    height = fullHeight - MARGIN.top - MARGIN.bottom;
  })();
  
  // conversions between dataval and axis position
  scale = {
    x: d3.time.scale().range([0, width]),
    y: d3.scale.linear().range([height, 0])
  };
  
  // axes with ticks
  axes = {
    x: d3.svg.axis().scale(scale.x).orient('bottom'),
    y: d3.svg.axis().scale(scale.y).orient('left')
  };
  
  // svg path line generating fn
  line = d3.svg.line()
    .x(pluck('datetime', scale.x))
    .y(pluck('steam', scale.y));
  
  // actual svg x axis
  var xAxis = svg.append('g')
    .attr('class', 'x axis')
    .attr('transform', 'translate(0,' + height + ')');
  
  // actual svg y axis
  var yAxis = svg.append('g')
    .attr('class', 'y axis');
  
  function update(error, data) {
    // parse json data
    data.forEach(function(d) {
      d.datetime = iso.parse(d.datetime);
      d.steam = +d.steam;
    });
    
    // set axis scales correctly
    scale.x.domain( d3.extent(data, pluck('datetime')) );
    scale.y.domain( d3.extent(data, pluck('steam')) );
    xAxis.call(axes.x);
    yAxis.call(axes.y);
    
    // add graph line
    svg.append('path')
      .datum(data)
      .attr('class', 'line')
      .attr('d', line);
      
    // add data dots
    svg.selectAll('circle')
      .data(data)
      .enter()
      .append('circle')
      .attr('cx', pluck('datetime', scale.x))
      .attr('cy', pluck('steam', scale.y))
      .attr('r', CIRCLE_RADIUS)
      .style('fill', 'steelblue')
      .style('cursor', 'pointer')
      .on('mouseover', pointover)
      .on('mouseout', pointout);
  }
  
  // replace this with a async JSON call d3.json('path/to.json', function(error, data) {})
  update(null, [
    { datetime: '2013-06-14T19:00:00Z', steam: '15640.4' },
    { datetime: '2013-06-14T18:00:00Z', steam: '15640.4' },
    { datetime: '2013-06-14T17:00:00Z', steam: '15786.0' }
  ]);
      
})();