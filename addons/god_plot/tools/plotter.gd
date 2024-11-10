@tool
class_name Plotter extends Control

var to_plot : Array[Plot] = []
var graph : Graph2D

func _init(graph_2D : Graph2D) -> void:
	graph = graph_2D

func _load_drawing_positions(series : Series) -> void:
	match series.type:
		Series.TYPE.SCATTER: _load_scatter_positions(series)
		Series.TYPE.LINE: _load_line_positions(series)
		Series.TYPE.AREA: _load_area_positions(series)

func _load_scatter_positions(series : ScatterSeries) -> void:
	for point in series.data:
		if not is_within_limits(point):
			continue
		var point_position = find_point_local_position(point)
		to_plot.append(ScatterPlot.new(point_position, series.color, series.size))

func _load_line_positions(line_series : LineSeries) -> void:
	var line := LinePlot.new(line_series.color, line_series.thickness)
	for point in line_series.data:
		if not is_within_limits(point): 
			continue
		var point_position = find_point_local_position(point)
		line.add_point(point_position)
	to_plot.append(line)

func _load_area_positions(series : AreaSeries) -> void:
	var points_within_limits = Array(series.data).filter(is_within_limits)
	if points_within_limits.size() < 2:
		return
	
	var area := AreaPlot.new(series.color)
	var base_y = find_y_coordinate_of_area_base()
	var starting_point := Vector2(
		find_point_local_position(points_within_limits[0]).x, base_y
	)
	area.add_point(starting_point)	
	
	for point in points_within_limits:
		var point_position = find_point_local_position(point)
		area.add_point(point_position)

	var ending_point := Vector2(
		find_point_local_position(points_within_limits[-1]).x, base_y
	)
	area.add_point(ending_point)
	to_plot.append(area)
	
func find_y_coordinate_of_area_base() -> float:
	if is_within_limits(Vector2(graph.pair_of_axes.get_min_limits().x, 0)):
		return find_point_local_position(Vector2(graph.pair_of_axes.get_min_limits().x, 0)).y
	if graph.pair_of_axes.get_min_limits().y < 0:
		return find_point_local_position(Vector2(graph.pair_of_axes.get_min_limits().x, graph.pair_of_axes.get_max_limits().y)).y
	return find_point_local_position(Vector2(graph.pair_of_axes.get_min_limits().x, graph.pair_of_axes.get_min_limits().y)).y

func is_within_limits(point : Vector2) -> bool:
	return 	point.clamp(graph.pair_of_axes.get_min_limits(), graph.pair_of_axes.get_max_limits()) == point

func find_point_local_position(point : Vector2) -> Vector2:
	var vector_from_graph_origin = point - graph.pair_of_axes.get_min_limits()
	var axes_range = graph.pair_of_axes.get_range()
	var position_from_origin = Vector2(
		vector_from_graph_origin.x / axes_range.x * (graph.pair_of_axes.x_axis.length - graph.axis_thickness/2),
		-vector_from_graph_origin.y / axes_range.y * (graph.pair_of_axes.y_axis.length - graph.axis_thickness/2)
		)
	return graph.get_zero_position() + position_from_origin 

func _draw() -> void:
	for plot_point in to_plot:
		plot_point.draw_on(self)
	to_plot = []
