@tool
class_name Graph2D extends Graph
## A node for creating two-dimensional quantitative graphs. 
## Used with a [Series2D] inheriting node to plot data on a 2D graph.

## Automatically adjusts axis min and max values to accommodate data. 
@export var auto_scaling : bool = true:
	set(value):
		auto_scaling = value
		queue_redraw()

@export_group("X Axis", "x_")
## Minimum value on x-axis. Precision must match [member x_decimal_places]
@export var x_min: float = 0.0: set = set_x_min
## Maximum value on x-axis. Precision must match [member x_decimal_places]
@export var x_max: float = 10.0: set = set_x_max

## Number of major gridlines. May change to ensure accurate position of gridlines. 
## More [member x_decimal_places] results in less variation.
@export var x_tick_count: int = 10:
	set(value):
		x_tick_count = value
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
@export_range(0, 10) var x_gridlines_minor : int = 0: set = set_x_gridlines_minor
@export var x_gridlines_minor_thickness : float = 1.0:
	set(value):
		x_gridlines_minor_thickness = value
		queue_redraw()

@export_group("Y Axis", "y_")
## Minimum value on y-axis. Precision must match [member y_decimal_places]
@export var y_min: float = 0.0: set = set_y_min
## Maximum value on y-axis. Precision must match [member y_decimal_places]
@export var y_max: float = 10.0: set = set_y_max

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
@export_range(0, 10) var y_gridlines_minor : int = 0: set = set_y_gridlines_minor
@export var y_gridlines_minor_thickness : float = 1.0:
	set(value):
		y_gridlines_minor_thickness = value
		queue_redraw()

var plotter : Plotter = Graph2DPlotter.new()

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
	get_children().filter(func(child): return child is Series2D).map(add_series)

func add_series(series : Series) -> void:
	series_container.add_series(series)

func remove_series(series : Series) -> void:
	series_container.remove_series(series)

func _draw() -> void:
	_update_graph_boundaries()
	GraphToAxesMapper.map_graph2d_to_pair_of_axes(self, pair_of_axes)
	pair_of_axes.queue_redraw()

func _update_graph_boundaries() -> void:
	var min_values = Vector2(x_min, y_min)
	var max_values = Vector2(x_max, y_max)
	
	if auto_scaling:
		var data_min = Rounder.floor_vector_to_decimal_places(
			series_container.min_value, Vector2(x_decimal_places, y_decimal_places)
			)
		var data_max = Rounder.ceil_vector_to_decimal_places(
			series_container.max_value, Vector2(x_decimal_places, y_decimal_places)
			)
		min_values = min_values.min(data_min)
		max_values = max_values.max(data_max)

	pair_of_axes.set_min_values(min_values)
	pair_of_axes.set_max_values(max_values)

func set_x_min(value : float) -> void:
	x_min = Rounder.round_num_to_decimal_place(value, x_decimal_places)
	if x_min > x_max: x_max = x_min
	queue_redraw()

func set_x_max(value : float) -> void:
	x_max = Rounder.round_num_to_decimal_place(value, x_decimal_places)
	if x_max < x_min: x_min = x_max
	queue_redraw()
	
func set_y_min(value : float) -> void:
	y_min = Rounder.round_num_to_decimal_place(value, y_decimal_places)
	if y_min > y_max: y_max = y_min
	queue_redraw()

func set_y_max(value : float) -> void:
	y_max = Rounder.round_num_to_decimal_place(value, y_decimal_places)
	if y_max < y_min: y_min = y_max
	queue_redraw()
	
func set_x_gridlines_minor(value : int):
		x_gridlines_minor = value
		queue_redraw()

func set_y_gridlines_minor(value : int):
		y_gridlines_minor = value
		queue_redraw()
