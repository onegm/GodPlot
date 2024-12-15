class_name Graph2DPlotter extends Plotter

func plot_all(series_arr : Array[Series]):
	to_plot.clear()
	var series2d_arr = series_arr.filter(_is_series2d)
	series2d_arr.map(_load_drawing_positions)
	queue_redraw()

static func _is_series2d(series : Series) -> bool:
	return series is Series2D

func _load_drawing_positions(series : Series2D) -> void:
	_update_axes_info()
	if series is ScatterSeries: 
		_load_scatter_positions(series)
	elif series is LineSeries:
		_load_line_positions(series)
	elif series is AreaSeries:
		_load_area_positions(series)

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

func is_within_limits(point : Vector2) -> bool:
	return 	point.clamp(min_limits, max_limits) == point
