@tool
class_name Plotter extends Control

var to_plot : Array[Plot] = []
var axes : PairOfAxes
var min_limits : Vector2
var max_limits : Vector2
var range : Vector2

func set_pair_of_axes(pair_of_axes : PairOfAxes):
	axes = pair_of_axes

func plot_all(series_arr : Array[Series]):
	to_plot = []
	for series in series_arr:
		_load_drawing_positions(series)
	queue_redraw()

func _load_drawing_positions(series : Series) -> void:
	_update_axes_info()
	if series is ScatterSeries: 
		_load_scatter_positions(series)
	elif series is LineSeries:
		_load_line_positions(series)
	elif series is AreaSeries:
		_load_area_positions(series)
	elif series is HistogramSeries:
		_load_histogram_positions(series)

func _update_axes_info():
	min_limits = axes.get_min_limits()
	max_limits = axes.get_max_limits()
	range = axes.get_range()

func _load_scatter_positions(series : ScatterSeries) -> void:
	for point in series.data:
		if not is_within_limits(point):
			continue
		var point_position = find_point_local_position(point)
		to_plot.append(ScatterPlot.from_scatter_series(point_position, series))

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
	var base_y = find_y_position_of_area_base()
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

func _load_histogram_positions(series : HistogramSeries) -> void:
	var base_y = find_y_position_of_area_base()
	var data = series.binned_data
	var bin_size = get_scaled_pixel_width(series.bin_size) * 0.95
	for bin in data:
		var area = AreaPlot.new(series.color)
		var bin_center = bin * series.bin_size + series.bin_size / 2
		var bin_position = find_point_local_position(Vector2(bin_center, data[bin]))
		bin_position.x -= axes.y_axis.thickness / 4.0
		area.add_point(Vector2(bin_position.x - bin_size/2.0, base_y))
		area.add_point(Vector2(bin_position.x - bin_size/2.0, bin_position.y))
		area.add_point(Vector2(bin_position.x + bin_size/2.0, bin_position.y))
		area.add_point(Vector2(bin_position.x + bin_size/2.0, base_y))
		to_plot.append(area)

func is_within_limits(point : Vector2) -> bool:
	return 	point.clamp(min_limits, max_limits) == point

func find_point_local_position(point : Vector2) -> Vector2:
	var position_from_minimum = point - min_limits
	var pixel_position_from_minimum = axes.get_pixel_position_from_minimum(position_from_minimum)
	return axes.get_axes_bottom_left_position() + pixel_position_from_minimum

func get_scaled_pixel_width(width : float) -> float:
	return remap(width, 0, axes.get_range().x, 0, axes.x_axis.length)

func find_y_position_of_area_base() -> float:
	if max_limits.y < 0:
		var top_edge_of_graph = max_limits
		return find_point_local_position(top_edge_of_graph).y
	
	if min_limits.y > 0:
		var bottom_edge_of_graph = min_limits
		return find_point_local_position(bottom_edge_of_graph).y
	
	var y_equals_zero = Vector2(min_limits.x, 0)
	return find_point_local_position(y_equals_zero).y

func _draw() -> void:
	for plot_point in to_plot:
		plot_point.draw_on(self)
