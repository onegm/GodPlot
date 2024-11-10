@tool
class_name SeriesContainer extends Node
## This class handles all series linked to a particular graph.

## Typed array of [Series] nodes to be plotted on the graph 
var series_arr : Array[Series] = []
var graph : Graph

func _init(the_graph : Graph) -> void:
	graph = the_graph

func is_series(node : Node) -> bool:
	return node is Series

func add_series(series : Series):
	if series_arr.has(series):
		return
	series_arr.append(series)
	series.property_changed.connect(graph.queue_redraw)
	graph.queue_redraw()
	
func remove_series(series : Series):
	series.property_changed.disconnect(graph.queue_redraw)
	series_arr.erase(series)

func get_all_series() -> Array[Series]:
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
