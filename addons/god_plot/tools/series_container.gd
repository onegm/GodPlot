@tool
class_name SeriesContainer extends Node
## This class handles all series linked to a particular graph.

## Typed array of [Series] nodes to be plotted on the graph 
var series_arr : Array[Series] = []
var graph : Graph

func _init(the_graph : Graph) -> void:
	graph = the_graph
	
func _ready() -> void:
	await get_tree().process_frame
	_load_series_in_order()
	graph.child_order_changed.connect(_load_series_in_order)
	graph.queue_redraw()

func _load_series_in_order() -> void:
	series_arr = []
	for series in graph.get_children().filter(is_series):
		series_arr.append(series)
	_connect_signals()
	graph.queue_redraw()

func is_series(node : Node) -> bool:
	return node is Series

func _connect_signals():
	for series in series_arr:
		if !series.property_changed.is_connected(graph.queue_redraw):
			series.property_changed.connect(graph.queue_redraw)

func remove_series(series : Series):
	graph.remove_child(series)

func get_all_series():
	return series_arr

func get_min_values() -> Vector2:
	var series_min_values := Vector2(INF, INF)
	for series in series_arr:
		for point in series.data:
			series_min_values = series_min_values.min(point)
	return series_min_values
	
func get_max_values() -> Vector2:
	var series_max_values := Vector2(-INF, -INF)
	for series in series_arr:
		for point in series.data:
			series_max_values = series_max_values.max(point)
	return series_max_values
