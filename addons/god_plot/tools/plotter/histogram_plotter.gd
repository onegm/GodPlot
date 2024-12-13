class_name HistogramPlotter extends Plotter

func _load_drawing_positions(series : Series) -> void:
	_update_axes_info()
	_load_histogram_positions(series)

func _update_axes_info():
	min_limits = axes.get_min_limits()
	max_limits = axes.get_max_limits()
	range = axes.get_range()

func _load_histogram_positions(series : HistogramSeries) -> void:
	var base_y = find_y_position_of_area_base()
	var keys_within_limits = series.binned_data.keys().filter(
		func(key): return is_within_limits(Vector2(series.x_min + key * series.bin_size,0))
	)
	var data = series.binned_data
	var bin_size = get_scaled_pixel_width(series.bin_size) * 0.95
	for bin in keys_within_limits:
		var area = AreaPlot.new(series.color)
		var bin_center = series.x_min + bin * series.bin_size + series.bin_size / 2
		var bin_position = find_point_local_position(Vector2(bin_center, data[bin]))
		bin_position.x -= axes.y_axis.thickness / 4.0
		area.add_point(Vector2(bin_position.x - bin_size/2.0, base_y))
		area.add_point(Vector2(bin_position.x - bin_size/2.0, bin_position.y))
		area.add_point(Vector2(bin_position.x + bin_size/2.0, bin_position.y))
		area.add_point(Vector2(bin_position.x + bin_size/2.0, base_y))
		to_plot.append(area)

func is_within_limits(point : Vector2) -> bool:
	var x_within_limits = point.x >= min_limits.x and point.x < max_limits.x
	var y_within_limits = clamp(point.y, min_limits.y, max_limits.y) == point.y
	return 	x_within_limits and y_within_limits

func get_scaled_pixel_width(width : float) -> float:
	return remap(width, 0, axes.get_range().x, 0, axes.x_axis.length)
