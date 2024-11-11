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

var major_gridline_positions : Array[Vector2] = []

func _init(origin : Axis, parallel : Axis) -> void:
	origin_axis = origin
	parallel_axis = parallel
	
func _draw() -> void:
	draw_major_gridlines()
	draw_minor_gridlines()

func draw_major_gridlines():
	major_gridline_positions = []
	for tick_num in (origin_axis.num_ticks + 1):
		var major_pos = origin + (origin_axis.thickness/2 + origin_axis.tick_interval * tick_num) * origin_axis.direction
		major_gridline_positions.append(major_pos)
		draw_line(
			major_pos,
			major_pos - parallel_axis.length * origin_axis.out_direction,
			color, major_thickness
			)

func draw_minor_gridlines():
	var minor_interval = origin_axis.tick_interval / float(minor_count + 1)	
	var all_but_last_major_gridline = major_gridline_positions.slice(0, -1)
	for major_pos in all_but_last_major_gridline:
		for line_num in minor_count:
			var minor_pos = major_pos + (line_num + 1) * minor_interval * origin_axis.direction
			draw_line(
				minor_pos,
				minor_pos - parallel_axis.length * origin_axis.out_direction, 
				color, minor_thickness
			)
