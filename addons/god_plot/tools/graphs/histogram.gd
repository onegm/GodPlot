@tool
class_name Histogram extends Graph

@export var bin_size : float = 10.0:
	set(value):
		bin_size = abs(value)
		x_max = _get_valid_x_max_from_value(x_max)
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

var series_container := SeriesContainer.new()

func _ready() -> void:
	super._ready()
	_setup_series_container()
	_connect_plotter_to_axes_with_deferred_plotting()
	child_order_changed.connect(_load_children_series)
	_load_children_series()

func _setup_series_container():
	add_child(series_container)
	series_container.redraw_requested.connect(queue_redraw)

func _connect_plotter_to_axes_with_deferred_plotting():
	pair_of_axes.draw.connect(
		plotter.call_deferred.bind("plot_all", series_container.get_all_series())
		)

func _load_children_series():
	if !is_inside_tree(): return
	get_children().filter(func(child): return child is HistogramSeries).map(add_series)

func add_series(series : HistogramSeries) -> void:
	series_container.add_series(series)

func remove_series(series : HistogramSeries) -> void:
	series_container.remove_series(series)

func _draw() -> void:
	_update_graph_limits()
	GraphToAxesMapper.map_histogram_to_pair_of_axes(self, pair_of_axes)
	pair_of_axes.queue_redraw()

func _update_graph_limits() -> void:
	if series_container.is_empty(): return 
	
	var min_limits = Vector2(x_min, 0)
	var max_limits = Vector2(x_max, 10.0)
	
	if auto_scaling:
		var data_min = Rounder.floor_vector_to_decimal_places(
			series_container.min_value, Vector2(x_decimal_places, y_decimal_places)
			)
		var data_max = Rounder.ceil_vector_to_decimal_places(
			series_container.max_value, Vector2(x_decimal_places, y_decimal_places)
			)
		min_limits = min_limits.min(data_min)
		max_limits = max_limits.max(data_max)

	pair_of_axes.set_min_limits(min_limits)
	pair_of_axes.set_max_limits(max_limits)

func clear_data():
	series_container.clear_data()
	
func _get_valid_x_max_from_value(value : float) -> float:
	return Rounder.ceil_num_to_multiple(value - x_min, bin_size) + x_min