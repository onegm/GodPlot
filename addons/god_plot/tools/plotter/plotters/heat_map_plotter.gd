class_name HeatMapPlotter extends Plotter

var heat_map : HeatMap
var bin_size_px : Vector2

func _init(heat_map_to_plot : HeatMap) -> void:
	heat_map = heat_map_to_plot
	
func plot_all(series_arr : Array[Series]):
	to_plot.clear()
	series_arr.filter(_is_heat_map_series).map(_load_drawing_positions)
	queue_redraw()

func _is_heat_map_series(series : Series) -> bool:
	return series is HeatMapSeries

func _load_drawing_positions(series : HeatMapSeries) -> void:
	_update_limits()
	bin_size_px = Vector2(_get_scaled_pixel_width(heat_map.bin_width), _get_scaled_pixel_height(heat_map.bin_height))
	_load_heat_map_positions(series)

func _load_heat_map_positions(series : HeatMapSeries) -> void:
	var bins = series.get_binned_data().keys()
	var bin_positions = bins.map(bin_to_graph_position)
	bin_positions.map(_load_heat_map_squares_positions.bind(Color.PINK))

func bin_to_graph_position(bin : Vector2) -> Vector2:
	return Vector2(
		heat_map.x_min + bin.x * heat_map.bin_width,
		heat_map.y_min + bin.y * heat_map.bin_height
	)

func _load_heat_map_squares_positions(square_center : Vector2, color : Color) -> void:
		if not is_within_limits(square_center):
			return
		var position_px = find_point_local_position(square_center)
		var square = ScatterPlot.new(
			position_px,
			color,
			heat_map.bin_width,
			ScatterSeries.SHAPE.SQUARE,
			true,
			0.0
			)
		print(_get_scaled_pixel_width(heat_map.bin_width), " :: ", axes.get_range().x)
		to_plot.append(square)

func is_within_limits(position : Vector2) -> bool:
	return position >= min_limits and position <= max_limits
