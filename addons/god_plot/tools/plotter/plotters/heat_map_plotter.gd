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
	var bins_plot_data : Dictionary = get_bin_positions_and_colors(series.get_binned_data())
	_load_heat_map_squares_positions(bins_plot_data)

func get_bin_positions_and_colors(binned_data : Dictionary) -> Dictionary:
	var result = {}
	for bin in binned_data:
		var position = bin_to_graph_position(bin)
		var color = heat_map.get_color_from_value(binned_data[bin])
		result[position] = color
	return result

func bin_to_graph_position(bin : Vector2) -> Vector2:
	return Vector2(
		heat_map.x_min + bin.x * heat_map.bin_width,
		heat_map.y_min + bin.y * heat_map.bin_height
	)

func _load_heat_map_squares_positions(bins_plot_data : Dictionary) -> void:
	for bin_position in bins_plot_data:
		if not is_within_limits(bin_position):
			continue
		var position_px = find_point_local_position(bin_position)
		var bin_color = bins_plot_data[bin_position]
		var rect = HeatMapRect.new(
			position_px,
			bin_color,
			bin_size_px
			)
		to_plot.append(rect)

func is_within_limits(position : Vector2) -> bool:
	return position >= min_limits and position <= max_limits
