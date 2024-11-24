@tool
class_name Graph2D extends Graph
## A node for creating two-dimensional quantitative graphs. 
## Used with a [Series] inheriting node to plot data on a 2D graph.

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
	get_children().filter(func(child): return child is Series).map(add_series)

func add_series(series : Series) -> void:
	series_container.add_series(series)

func remove_series(series : Series) -> void:
	series_container.remove_series(series)

func _draw() -> void:
	_update_graph_limits()
	super._draw()

func _update_graph_limits() -> void:
	var min_limits = Vector2(x_min, y_min)
	var max_limits = Vector2(x_max, y_max)
	
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
