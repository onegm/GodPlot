@tool
class_name Plotter extends Control
## Class responsible for drawing data onto the graph.

var to_plot : Array[PlotData] = []
var graph : QuantitativeGraph

func _init(q_graph : QuantitativeGraph) -> void:
	graph = q_graph

func add_plot_data(plot_data : PlotData) -> void:
	to_plot.append(plot_data)

func _plot_series(series : QuantitativeSeries) -> void:
	## Populates the [member to_draw] array using the given [QuantitativeSeries] parameter.
	match series.type:
		QuantitativeSeries.TYPE.SCATTER: _plot_scatter(series)
		QuantitativeSeries.TYPE.LINE: _plot_line(series)
		QuantitativeSeries.TYPE.AREA: _plot_area(series)

func _plot_scatter(series : QuantitativeSeries) -> void:
	## This method is called by [method _plot_series] on all [QuantitativeSeries] nodes with type 
	## [constant QuantitativeSeries.TYPE.SCATTER]. All points in the series will be mapped to global coordinates
	## and appended to [member to_draw] along with color and size information.
	for point in series.data:
		if not graph.is_within_limits(point): continue
		var point_position = graph.find_point_local_postion(point)
		to_plot.append(PlotData.new(series.type, series.color, series.size).add_point(point_position))

func _plot_line(series : QuantitativeSeries) -> void:
	## This method is called by [method _plot_series] on all [QuantitativeSeries] nodes with type 
	## [constant QuantitativeSeries.TYPE.LINE]. All points in the series will be mapped to global coordinates
	## and appended to [member to_draw] as a [PackedVector2Array] along with color and size information.
	## Must include a minimum of two data points to be plotted. Points must be within bounds unless 
	## [constant QuantitativeGraph.auto_scaling] is enabled.
	if series.data.size() < 2: return
	var plot_data = PlotData.new(series.type, series.color, series.size)
	for point in series.data:
		if not graph.is_within_limits(point): continue
		var point_position = graph.find_point_local_postion(point)
		plot_data.add_point(point_position)
	to_plot.append(plot_data)

func _plot_area(series : QuantitativeSeries) -> void:
	## This method is called by [method _plot_series] on all [QuantitativeSeries] nodes with type 
	## [constant QuantitativeSeries.TYPE.AREA]. All points in the series will be mapped to global coordinates
	## and appended to [member to_draw] as an array of [PackedVector2Array]s along with color information.
	## Must include a minimum of two data points to be plotted. Points must be within bounds unless 
	## [constant QuantitativeGraph.auto_scaling] is enabled.
	var polygon : PackedVector2Array
	var first_x_coordinate := graph.min_limits.x - 1.0
	var last_x_coordinate := graph.min_limits.x - 1.0
	var zero_y = min(graph.find_point_local_postion(Vector2(0,0)).y, 
					 graph.find_point_local_postion(graph.min_limits).y)
	var found_first := false
	for point in series.data:
		if not graph.is_within_limits(point): continue
		var point_position = graph.find_point_local_postion(point)
		if !found_first:
			first_x_coordinate = point_position.x
			polygon.append(Vector2(point_position.x, zero_y))
			found_first = true
		polygon.append(point_position)
		last_x_coordinate = point_position.x
		
	if polygon.size() < 3: return
	polygon.append(Vector2(last_x_coordinate, zero_y))
	var poly_array = Geometry2D.merge_polygons(polygon, PackedVector2Array([]))
	for piece in poly_array:
		#to_draw.append([series.type, piece, series.color])
		to_plot.append(PlotData.new(series.type, series.color).set_points(piece))

func _draw() -> void:
	for plot_point in to_plot:
		match plot_point.type:
			QuantitativeSeries.TYPE.SCATTER:
				draw_circle(plot_point.points[0], plot_point.size, plot_point.color)
			QuantitativeSeries.TYPE.LINE:
				draw_polyline(plot_point.points, plot_point.color, plot_point.size, true)
			QuantitativeSeries.TYPE.AREA:
				draw_colored_polygon(plot_point.points, plot_point.color)
	to_plot = []
