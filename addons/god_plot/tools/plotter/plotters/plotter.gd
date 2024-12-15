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

func _draw() -> void:
	for plot_point in to_plot:
		plot_point.draw_on(self)
