@tool
class_name Graph2D extends Graph
## A node for creating two-dimensional quantitative graphs. 
## Used with a [Series] inheriting node to plot data on a 2D graph.

var series_container := SeriesContainer.new()
var min_limits := Vector2(x_min, y_min)
var max_limits := Vector2(x_max, y_max)

func _ready() -> void:
	super._ready()
	add_child(series_container)
	series_container.redraw_requested.connect(queue_redraw)
	child_order_changed.connect(_load_children_series)
	_load_children_series()

func _load_children_series():
	get_children().filter(func(child): return child is Series).map(add_series)

func add_series(series : Series) -> void:
	series_container.add_series(series)

func remove_series(series : Series) -> void:
	series_container.remove_series(series)

func _draw() -> void:
	_update_graph_limits()
	super._draw()
	plotter.plot_all(series_container.get_all_series())

func _update_graph_limits() -> void:
	min_limits = Vector2(x_min, y_min)
	max_limits = Vector2(x_max, y_max)
	
	if auto_scaling:
		min_limits = series_container.get_min_value().min(min_limits)
		max_limits = series_container.get_max_value().max(max_limits)
