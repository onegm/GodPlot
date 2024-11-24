@tool
class_name AxisLabels extends CanDraw

var axis : Axis
var font : Font = SystemFont.new()
var font_size : float
var canvas : CanvasItem
var visible : bool

func _init(axis_to_label : Axis) -> void:
	axis = axis_to_label

func draw_on(canvas_item : CanvasItem):
	if !visible: return
	canvas = canvas_item
	var tick_positions_along_edge : Array = get_tick_positions_along_edge()
	var tick_values : Array = axis.get_label_values_at_ticks()
	for i in tick_positions_along_edge.size():
		var value = tick_values[i]
		var str_value = "%0.*f" % [axis.decimal_places, value]
		var offset = _calculate_label_offset(str_value.length())
		var start = tick_positions_along_edge[i]
		draw_label(start + offset, str_value)

func get_tick_positions_along_edge() -> Array:
	return axis.get_tick_positions_along_axis().map(_transform_position_to_vector)

func _transform_position_to_vector(tick_position : float): 
	return tick_position * axis.direction

func _calculate_label_offset(string_length : int) -> Vector2:
	var offset = axis.out_direction * (axis.get_tick_length() + font_size)
	if axis.is_vertical:
		offset += axis.out_direction * font_size/2.0 * (string_length - 1)
		offset -= axis.direction * font_size / 3.0
	else:
		offset -= axis.direction * font_size / 3.5 * string_length
	return offset

func draw_label(label_position : Vector2, str : String):
	canvas.draw_string(
		font, label_position, 
		str, HORIZONTAL_ALIGNMENT_LEFT, -1,
		font_size, axis.color
		)
