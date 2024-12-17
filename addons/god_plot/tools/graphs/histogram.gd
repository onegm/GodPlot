@tool
class_name Histogram extends Graph
## A node for creating histograms. 
## Use with a [HistogramSeries] to plot one-dimensional data.

enum OUTLIER {
	IGNORE, ## Outlier data will not be included in the histogram
	INCLUDE, ## Outlier data will be included in the closest bin
	FIT ## X-Axis will expand to fit data
}

@export var bin_size : float = 10.0:
	set(value):
		bin_size = abs(value)
		x_max = _get_valid_x_max_from_value(x_max)
		queue_redraw()
@export_range(0.1, 1.0) var bar_width_scale = 0.95
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
## Maximum value on x-axis. Value will snap to multiple of [member bin_size]
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
@export var x_gridlines_major_thickness : float = 1.0:
	set(value):
		x_gridlines_major_thickness = value
		queue_redraw()

@export_group("Y Axis", "y_")
## Starting maximum value of y-axis. Will increase automatically if data exceeds it. 
@export var y_max: float = 10.0:
	set(value):
		y_max = abs(value)
		queue_redraw()
## Number of major gridlines. May change to ensure accurate position of gridlines. 
## More [member y_decimal_places] results in less variation.
@export var y_tick_count: int = 10:
	set(value):
		y_tick_count = value
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
@export var y_gridlines_major_thickness : float = 1.0:
	set(value):
		y_gridlines_major_thickness = value
		queue_redraw()
@export_range(0, 10) var y_gridlines_minor : int = 0:
	set(value):
		y_gridlines_minor = value
		queue_redraw()
@export var y_gridlines_minor_thickness : float = 1.0:
	set(value):
		y_gridlines_minor_thickness = value
		queue_redraw()

var plotter = HistogramPlotter.new(self)

func _ready() -> void:
	super._ready()
	_setup_plotter()
	child_order_changed.connect(_load_children_series)
	_load_children_series()
	
func _setup_plotter():
	plotter.set_pair_of_axes(pair_of_axes)
	pair_of_axes.add_child(plotter)
	_connect_plotter_to_axes_with_deferred_plotting()

func _connect_plotter_to_axes_with_deferred_plotting():
	pair_of_axes.draw.connect(
		plotter.call_deferred.bind("plot_all", series_container.get_all_series())
		)

func _load_children_series():
	if !is_inside_tree(): return
	get_children().filter(func(child): return child is HistogramSeries).map(add_series)

func add_series(series : HistogramSeries) -> void:
	series_container.add_series(series)
	_update_series_properties(series)

func remove_series(series : HistogramSeries) -> void:
	series_container.remove_series(series)

func _draw() -> void:
	_update_graph_limits()
	_update_all_series()
	GraphToAxesMapper.map_histogram_to_pair_of_axes(self, pair_of_axes)
	pair_of_axes.queue_redraw()

func _update_graph_limits() -> void:
	var min_limits = Vector2(x_min, 0)
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
		data_max_x += bin_size / 2.0
	data_max_x = _get_valid_x_max_from_value(data_max_x)
	return data_max_x

func _get_valid_x_max_from_value(value : float) -> float:
	return Rounder.ceil_num_to_multiple(value - x_min, bin_size) + x_min

func _get_valid_x_min_from_value(value : float) -> float:
	return Rounder.floor_num_to_multiple(value - x_min, bin_size) + x_min

func _is_on_bin_edge(value : float) -> bool:
	return is_equal_approx(value, _get_valid_x_max_from_value(value))

func _update_all_series():
	series_container.get_all_series().map(_update_series_properties)

func _update_series_properties(series : HistogramSeries):
	series.set_properties_from_histogram(self)

func get_x_tick_count() -> int:
	return int(pair_of_axes.get_range().x / bin_size)
