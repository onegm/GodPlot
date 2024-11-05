@tool
class_name Plotter extends Control
## Class responsible for drawing data onto the graph.

var to_plot : Array[PlotData] = []
var graph : Graph2D

func _init(graph_2D : Graph2D) -> void:
	graph = graph_2D

func _load_drawing_positions(series : Series) -> void:
	match series.type:
		Series.TYPE.SCATTER: _load_scatter_positions(series)
		Series.TYPE.LINE: _load_line_positions(series)
		Series.TYPE.AREA: _load_area_positions(series)

func _load_scatter_positions(series : Series) -> void:
	for point in series.data:
		if not is_within_limits(point): continue
		var point_position = find_point_local_position(point)
		to_plot.append(PlotData.new_scatter_point(point_position, series.color, series.size))

func _load_line_positions(series : Series) -> void:
	if series.data.size() < 2: return
	var line = PlotData.new_line(series.color, series.size)
	for point in series.data:
		if not is_within_limits(point): continue
		var point_position = find_point_local_position(point)
		line.add_point(point_position)
	to_plot.append(line)

func _load_area_positions(series : Series) -> void:
	var polygon : PackedVector2Array
	var first_x_coordinate := graph.min_limits.x - 1.0
	var last_x_coordinate := graph.min_limits.x - 1.0
	var zero_y = min(find_point_local_position(Vector2(0,0)).y, 
					 find_point_local_position(graph.min_limits).y)
	var found_first := false
	for point in series.data:
		if not is_within_limits(point): continue
		var point_position = find_point_local_position(point)
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
		to_plot.append(PlotData.new_area(piece, series.color))

func is_within_limits(point : Vector2) -> bool:
	return 	point.clamp(graph.min_limits, graph.max_limits) == point

func find_point_local_position(point : Vector2) -> Vector2:
	var vector_from_graph_origin = point - graph.min_limits
	var position_from_origin = Vector2(
		vector_from_graph_origin.x / graph.range.x * (graph.x_axis.length - graph.axis_thickness/2),
		-vector_from_graph_origin.y / graph.range.y * (graph.y_axis.length - graph.axis_thickness/2)
		)
	return graph.get_zero_position() + position_from_origin 

func _draw() -> void:
	for plot_point in to_plot:
		match plot_point.type:
			Series.TYPE.SCATTER:
				## Use a callable from ScatterPoint class instead??
				draw_circle(plot_point.points[0], plot_point.size, plot_point.color)
			Series.TYPE.LINE:
				draw_polyline(plot_point.points, plot_point.color, plot_point.size, true)
			Series.TYPE.AREA:
				draw_colored_polygon(plot_point.points, plot_point.color)
	to_plot = []
