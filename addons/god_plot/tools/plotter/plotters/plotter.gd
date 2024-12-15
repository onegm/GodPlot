class_name Plotter extends Control

var to_plot : Array[Plot] = []
var axes : PairOfAxes
var min_limits : Vector2
var max_limits : Vector2
var range : Vector2

func set_pair_of_axes(pair_of_axes : PairOfAxes):
	axes = pair_of_axes

func _update_axes_info():
	min_limits = axes.get_min_limits()
	max_limits = axes.get_max_limits()
	range = axes.get_range()

func find_point_local_position(point : Vector2) -> Vector2:
	var position_from_minimum = point - min_limits
	var pixel_position_from_minimum = axes.get_pixel_position_from_minimum(position_from_minimum)
	return axes.get_axes_bottom_left_position() + pixel_position_from_minimum

func find_y_position_of_area_base() -> float:
	if max_limits.y < 0:
		var top_edge_of_graph = max_limits
		return find_point_local_position(top_edge_of_graph).y
	
	if min_limits.y > 0:
		var bottom_edge_of_graph = min_limits
		return find_point_local_position(bottom_edge_of_graph).y
	
	var y_equals_zero = Vector2(min_limits.x, 0)
	return find_point_local_position(y_equals_zero).y

func _draw() -> void:
	for plot_point in to_plot:
		plot_point.draw_on(self)
