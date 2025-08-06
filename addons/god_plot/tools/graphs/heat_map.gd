@tool
class_name HeatMap extends Graph
## A node for creating heat maps.

enum OUTLIER {
	IGNORE, ## Outlier data will not be included in the histogram
	INCLUDE, ## Outlier data will be included in the closest bin
	FIT ## Axes will expand to fit data
}
@export var gradient : Gradient = Gradient.new()
@export var bin_width : float = 10.0:
	set(value):
		bin_width = abs(value)
		x_max = _get_valid_x_max_from_value(x_max)
		queue_redraw()
@export var bin_height : float = 10.0:
	set(value):
		bin_height = abs(value)
		y_max = _get_valid_y_max_from_value(y_max)
		queue_redraw()
@export var outlier_behavior : OUTLIER = OUTLIER.IGNORE:
	set(value):
		outlier_behavior = value
		queue_redraw()
@export_group("X Axis", "x_")
## Minimum value on x-axis. Precision must match [member x_decimal_places]
@export var x_min: float = 0.0:
	set(value):
		x_min = Rounder.round_num_to_decimal_place(value, x_decimal_places)
		if x_min > x_max: x_max = x_min
		x_max = _get_valid_x_max_from_value(x_max)
		queue_redraw()
## Maximum value on x-axis. Value will snap to multiple of [member bin_width]
@export var x_max: float = 10.0:
	set(value):
		x_max = _get_valid_x_max_from_value(value)
		if x_max < x_min: x_min = x_max
		queue_redraw()
@export_range(0, 5) var x_decimal_places : int = 1:
	set(value):
		x_decimal_places = value
		queue_redraw()
@export_subgroup("Gridlines", "x_gridlines")
@export_range(0, 1) var x_gridlines_opacity : float = 1.0:
	set(value):
		x_gridlines_opacity = value
		queue_redraw()
@export var x_gridlines_thickness : float = 1.0:
	set(value):
		x_gridlines_thickness = value
		queue_redraw()

@export_group("Y Axis", "y_")
## Minimum value on y-axis. Precision must match [member y_decimal_places]
@export var y_min: float = 0.0:
	set(value):
		y_min = Rounder.round_num_to_decimal_place(value, y_decimal_places)
		if y_min > y_max: y_max = y_min
		y_max = _get_valid_y_max_from_value(y_max)
		queue_redraw()
## Maximum value on y-axis. Value will snap to multiple of [member bin_height] 
@export var y_max: float = 10.0:
	set(value):
		y_max = abs(value)
		queue_redraw()
@export_range(0, 5) var y_decimal_places : int = 1:
	set(value):
		y_decimal_places = value
		queue_redraw()
@export_subgroup("Gridlines", "y_gridlines")
@export_range(0, 1) var y_gridlines_opacity : float = 1.0:
	set(value):
		y_gridlines_opacity = value
		queue_redraw()
@export var y_gridlines_thickness : float = 1.0:
	set(value):
		y_gridlines_thickness = value
		queue_redraw()

#var plotter = HistogramPlotter.new(self)

func _ready() -> void:
	super._ready()
	_setup_plotter()
	
func _setup_plotter():
	#plotter.set_pair_of_axes(pair_of_axes)
	#pair_of_axes.add_child(plotter)
	_connect_plotter_to_axes_with_deferred_plotting()

func _connect_plotter_to_axes_with_deferred_plotting():
	#pair_of_axes.draw.connect(
		#plotter.call_deferred.bind("plot_all", series_container.get_all_series())
		#)
	pass

func _draw() -> void:
	_update_graph_limits()
	#GraphToAxesMapper.map_histogram_to_pair_of_axes(self, pair_of_axes)
	pair_of_axes.queue_redraw()

func _update_graph_limits() -> void:
	var min_limits = Vector2(x_min, y_min)
	var max_limits = Vector2(x_max, y_max)
	
	var data_max_y = Rounder.ceil_num_to_decimal_place(
		series_container.max_value.y, y_decimal_places
		)
	max_limits = max_limits.max(Vector2(x_max, data_max_y))
	
	if outlier_behavior == OUTLIER.FIT:
		var data_max_x = _get_valid_x_max_from_data()
		var data_min_x = _get_valid_x_min_from_value(series_container.min_value.x)

		max_limits.x = max(data_max_x, max_limits.x)
		min_limits.x = min(data_min_x, min_limits.x)
	
	pair_of_axes.set_min_limits(min_limits)
	pair_of_axes.set_max_limits(max_limits)
	
func _get_valid_x_max_from_data() -> float:
	var data_max_x = series_container.max_value.x
	if _is_on_bin_edge(data_max_x):
		data_max_x += bin_width / 2.0
	data_max_x = _get_valid_x_max_from_value(data_max_x)
	return data_max_x

func _get_valid_x_max_from_value(value : float) -> float:
	return Rounder.ceil_num_to_multiple(value - x_min, bin_width) + x_min

func _get_valid_y_max_from_value(value : float) -> float:
	return Rounder.ceil_num_to_multiple(value - y_min, bin_height) + y_min

func _get_valid_x_min_from_value(value : float) -> float:
	return Rounder.floor_num_to_multiple(value - x_min, bin_width) + x_min

func _get_valid_y_min_from_value(value : float) -> float:
	return Rounder.floor_num_to_multiple(value - y_min, bin_height) + y_min

func _is_on_bin_edge(value : float) -> bool:
	return is_equal_approx(value, _get_valid_x_max_from_value(value))

func get_x_tick_count() -> int:
	return int(pair_of_axes.get_range().x / bin_width)

func get_y_tick_count() -> int:
	return int(pair_of_axes.get_range().y / bin_height)
