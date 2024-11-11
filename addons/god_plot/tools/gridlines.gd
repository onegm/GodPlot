@tool
class_name Gridlines extends Control
## Class responsible for drawing gridlines on the graph. An instance of [Gridlines]
## only draws either the vertical or horizontal gridlines.

var color : Color
var major_thickness : float = 1.0
var minor_thickness : float = 1.0
var minor_count : int = 0
## The axis from which the gridlines are drawn. The major gridlines will match the ticks on that axis.
var origin_axis : Axis
## The axis parallel to the gridlines. The gridlines will match the length of this axis.
var parallel_axis : Axis

var origin := Vector2.ZERO

func _init(origin : Axis, parallel : Axis) -> void:
	origin_axis = origin
	parallel_axis = parallel
	
func _draw() -> void:
	var minor_interval = origin_axis.tick_interval / float(minor_count + 1)	
	for tick_num in (origin_axis.num_ticks + 1):
		var major_pos = origin + (origin_axis.thickness/2 + origin_axis.tick_interval * tick_num) * origin_axis.direction
		draw_line(
			major_pos,
			major_pos - parallel_axis.length * origin_axis.out_direction,
			color, major_thickness
			)
		for line_num in minor_count:
			var minor_pos = major_pos - (line_num + 1) * minor_interval * origin_axis.direction
			draw_line(
				minor_pos,
				minor_pos - parallel_axis.length * origin_axis.out_direction, 
				color, minor_thickness
			)
