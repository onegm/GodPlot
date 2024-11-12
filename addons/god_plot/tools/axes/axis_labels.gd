@tool
class_name AxisLabels extends Control

var axis : Axis
var font_size : float
var decimal_places : int = 0

func _init(axis_to_label : Axis) -> void:
	axis = axis_to_label

func _draw():
	if !axis.num_ticks: return
	var tick_positions_along_edge : Array = get_tick_positions_along_edge()
	var tick_values : Array = axis.get_value_at_each_tick()
	for i in tick_positions_along_edge.size():
		var value = tick_values[i]
		var str_value = "%0.*f" % [decimal_places, value]
		var offset = _calculate_label_offset(str_value.length())
		var start = tick_positions_along_edge[i]
		draw_label(start + offset, str_value)

func get_tick_positions_along_edge() -> Array:
	return axis.tick_positions_along_axis.map(
		func(tick_position): return tick_position * axis.direction
		)

func _calculate_label_offset(string_length : int) -> Vector2:
	var offset = axis.out_direction * (axis.tick_length + font_size)
	if axis.is_vertical:
		offset += axis.out_direction * font_size/2.0 * (string_length - 1)
		offset -= axis.direction * font_size / 3.0
	else:
		offset -= axis.direction * font_size / 3.5 * string_length
	return offset

func draw_label(label_position : Vector2, str : String):
	draw_string(
		get_theme_default_font(), label_position, 
		str, HORIZONTAL_ALIGNMENT_LEFT, -1,
		font_size, axis.color
		)
