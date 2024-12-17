class_name HistogramPlotter extends Plotter

var histogram : Histogram
var bin_size_px : float = 10.0
var bar_width_scale : float = 1.0
var base_y : float = 0.0

func _init(histogram_to_plot : Histogram) -> void:
	histogram = histogram_to_plot

func plot_all(series_arr : Array[Series]):
	to_plot.clear()
	series_arr.filter(_is_histogram_series).map(_load_drawing_positions)
	queue_redraw()

static func _is_histogram_series(series : Series) -> bool:
	return series is HistogramSeries

func _load_drawing_positions(series : HistogramSeries) -> void:
	_update_limits()
	base_y = find_y_position_of_bar_base()
	bin_size_px = _get_scaled_pixel_width(histogram.bin_size) * histogram.bar_width_scale
	_load_histogram_positions(series)

func _load_histogram_positions(series : HistogramSeries) -> void:
	var binned_data : Array[Vector2] = series.get_binned_data()
	binned_data.map(_load_histogram_bar.bind(series.color))

func _load_histogram_bar(bar_center_top : Vector2, color : Color) -> void:
		if not is_within_limits(bar_center_top.x):
			return
		var bar_center_top_px = find_point_local_position(bar_center_top)
		bar_center_top_px.x -= axes.y_axis.thickness / 4.0
		var area = AreaPlot.new(color)
		_get_four_corners(bar_center_top_px).map(area.add_point)
		to_plot.append(area)

func _get_four_corners(top_center : Vector2) -> Array[Vector2]:
	return [
		Vector2(top_center.x - bin_size_px/2.0, base_y),
		Vector2(top_center.x - bin_size_px/2.0, top_center.y),
		Vector2(top_center.x + bin_size_px/2.0, top_center.y),
		Vector2(top_center.x + bin_size_px/2.0, base_y)
	]

func find_y_position_of_bar_base() -> float:
	var y_equals_zero = Vector2(min_limits.x, 0)
	return find_point_local_position(y_equals_zero).y - axes.x_axis.thickness / 2.0

func _get_scaled_pixel_width(width : float) -> float:
	return remap(width, 0, axes.get_range().x, 0, axes.x_axis.length)

func is_within_limits(value : float) -> bool:
	return 	value >= min_limits.x and value < max_limits.x
