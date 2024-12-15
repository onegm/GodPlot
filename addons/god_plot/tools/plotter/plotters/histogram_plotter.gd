class_name HistogramPlotter extends Plotter

var bin_size_px : float = 10.0

func plot_all(series_arr : Array[Series]):
	to_plot.clear()
	var histogram_series_arr = series_arr.filter(_is_histogram_series)
	histogram_series_arr.map(_load_drawing_positions)
	queue_redraw()

static func _is_histogram_series(series : Series) -> bool:
	return series is HistogramSeries

func _load_drawing_positions(series : HistogramSeries) -> void:
	_update_axes_info()
	_load_histogram_positions(series)

func _load_histogram_positions(series : HistogramSeries) -> void:
	var base_y = find_y_position_of_bar_base()
	bin_size_px = _get_scaled_pixel_width(series.bin_size) * 0.95
	var bin_center_positions : Dictionary = series.get_bin_center_positions()
	for bin in bin_center_positions:
		var bin_center = bin_center_positions[bin]
		if not is_within_limits(bin_center):
			continue
		var area = AreaPlot.new(series.color)
		var bin_position = find_point_local_position(Vector2(bin_center, series.get_bin_count(bin)))
		bin_position.x -= axes.y_axis.thickness / 4.0
		area.add_point(Vector2(bin_position.x - bin_size_px/2.0, base_y))
		area.add_point(Vector2(bin_position.x - bin_size_px/2.0, bin_position.y))
		area.add_point(Vector2(bin_position.x + bin_size_px/2.0, bin_position.y))
		area.add_point(Vector2(bin_position.x + bin_size_px/2.0, base_y))
		to_plot.append(area)

func find_y_position_of_bar_base() -> float:
	var y_equals_zero = Vector2(min_limits.x, 0)
	return find_point_local_position(y_equals_zero).y - axes.x_axis.thickness / 2.0

func _get_scaled_pixel_width(width : float) -> float:
	return remap(width, 0, axes.get_range().x, 0, axes.x_axis.length)

func is_within_limits(value : float) -> bool:
	return 	value >= min_limits.x and value < max_limits.x
