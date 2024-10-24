@tool
class_name Gridlines extends Control

var color : Color
var major_thickness : float = 1.0
var minor_thickness : float = 1.0
var minor_count : int = 2
var origin_axis : Axis
var parallel_axis : Axis

func _init(origin : Axis, parallel : Axis) -> void:
	origin_axis = origin
	parallel_axis = parallel
	
func _draw() -> void:
	var minor_interval = origin_axis.tick_interval / float(minor_count + 1)	
	for tick_num in origin_axis.num_ticks:
		var major_pos = origin_axis.origin + tick_num * origin_axis.tick_interval * origin_axis.direction
		draw_line(
			major_pos,
			major_pos - parallel_axis.length * origin_axis.out_direction,
			color, major_thickness
			)
		for line_num in minor_count:
			var minor_pos = major_pos + (line_num + 1) * minor_interval * origin_axis.direction
			draw_line(
				minor_pos,
				minor_pos - parallel_axis.length * origin_axis.out_direction, 
				color, minor_thickness
			)
