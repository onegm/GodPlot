@tool
class_name Axis extends Control
## Class used to draw a custom axis. 

## Axis is oriented horizontally by default. If enabled, axis will be oriented vertically.
var is_vertical : bool = false: 
	set(value):
		is_vertical = value
		direction = Vector2.UP if is_vertical else Vector2.RIGHT
		out_direction = Vector2.LEFT if is_vertical else Vector2.DOWN
## The minimum value shown on the axis.
var min_value : float = 0
## The maximum value shown on the axis.
var max_value : float = 10
## The pixel length of the axis.
var length : float = 500.0:
	set(value):
		length = max(0, value)
		_update_tick_interval()
## The pixel thickness of the axis.
var thickness : float = 5.0:
	set(value):
		thickness = max(0, value)
		tick_length = 2 * thickness
## The color of the axis and its ticks.
var color : Color = Color.BLACK
## The number of ticks shown on the axis. No tick is drawn at the minimum value.
var num_ticks : int = 10:
	set(value):
		num_ticks = max(0, value)
		_update_tick_interval()
## The position of the axis origin relative the control node parent. 
var origin : Vector2 = Vector2.ZERO
## The direction along the axis. [constant Vector2.RIGHT] for the horizontal and 
## [constant Vector2.UP] for the vertical orientation. 
var direction : Vector2 = Vector2.RIGHT
## The direction "out" of the graph. [constant Vector2.DOWN] for the horizontal 
## and [constant Vector2.LEFT] for the vertical orientation
var out_direction : Vector2 = Vector2.DOWN
## Spacing between ticks. 
var tick_interval : float = 0.0
## Pixel length of ticks
var tick_length : float = 10.0
## Used to show/hide values by the axis ticks.
var show_tick_labels : bool = true
## Font size of the tick labels.
var font_size : int = 16
## Number of decimal places shown in tick labels. 
var decimal_places : int = 0

func _draw() -> void:
	draw_circle(origin, thickness/2, color)
	draw_line(origin, origin + length * direction, color, thickness)
	draw_circle(origin + length * direction, thickness/2, color)
	_draw_ticks()
	_draw_tick_labels()
	
func _draw_ticks() -> void:
	for i in range(num_ticks):
		var start = origin + tick_interval * direction*(i+1)
		draw_line(start , start + tick_length * out_direction,
				  color, thickness / 3)

func _draw_tick_labels() -> void:
	if !num_ticks or !show_tick_labels: return
	var axis_range = max_value - min_value
	for i in range(num_ticks + 1):
		var value = min_value + axis_range / num_ticks * i
		var str_value = "%0.*f" % [decimal_places, value]
		var offset = _calculate_label_offset(str_value.length())
		var start = origin + tick_interval * direction * i
		draw_string(get_theme_default_font(), start + offset, 
					str_value, HORIZONTAL_ALIGNMENT_LEFT, -1,
					font_size, color)

func _calculate_label_offset(string_length : int) -> Vector2:
	var offset = out_direction * (tick_length + font_size)
	if is_vertical:
		offset += out_direction * font_size/2.0 * (string_length - 1)
		offset -= direction * font_size / 3.0
	else:
		offset -= direction * font_size / 3.5 * string_length
	return offset

func _update_tick_interval():
	tick_interval = length / float(num_ticks) if num_ticks else 0
