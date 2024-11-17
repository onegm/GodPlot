@tool
class_name PairOfAxes extends Control

var x_axis := Axis.new_x_axis()
var y_axis := Axis.new_y_axis()
var x_gridlines := Gridlines.new(x_axis, y_axis)
var y_gridlines := Gridlines.new(y_axis, x_axis)
var x_labels := AxisLabels.new(x_axis)
var y_labels := AxisLabels.new(y_axis)

var bottom_left_corner := Marker2D.new()

var margin := {
	"top" : 0.0,
	"left": 0.0,
	"right": 0.0,
	"bottom": 0.0
	}
var y_title_margin : float = 0.0

var color : Color:
	set(value):
		color = value
		x_axis.color = color
		y_axis.color = color
		
var thickness : float:
	set(value):
		thickness = value
		x_axis.thickness = thickness
		y_axis.thickness = thickness

var font_size : float:
	set(value):
		font_size = value
		x_labels.font_size = font_size
		y_labels.font_size = font_size

var num_ticks : Vector2i:
	set(value):
		num_ticks = value
		x_axis.num_ticks = num_ticks.x
		y_axis.num_ticks = num_ticks.y

var visible_tick_labels : bool:
	set(value):
		visible_tick_labels = value
		x_labels.visible = visible_tick_labels
		y_labels.visible = visible_tick_labels

var decimal_places : Vector2i:
	set(value):
		decimal_places = value
		x_axis.decimal_places = decimal_places.x
		y_axis.decimal_places = decimal_places.y
	
func _ready() -> void:
	add_child(bottom_left_corner)
	for object in [x_axis, y_axis, x_gridlines, y_gridlines, x_labels, y_labels]:
		bottom_left_corner.add_child(object)

func get_min_limits() -> Vector2: return Vector2(x_axis.min_value, y_axis.min_value)
	
func set_min_limits(min_limits : Vector2):
	x_axis.min_value = min_limits.x
	y_axis.min_value = min_limits.y
	
func get_max_limits() -> Vector2: return Vector2(x_axis.max_value, y_axis.max_value)
	
func set_max_limits(max_limits : Vector2):
	x_axis.max_value = max_limits.x
	y_axis.max_value = max_limits.y

func get_range() -> Vector2:
	return Vector2(x_axis.get_range(), y_axis.get_range())
	
func _draw() -> void:
	_update_margin()
	_set_bottom_left_corner()
	_set_axes_origin_positions_and_lengths()
	x_axis.queue_redraw()
	y_axis.queue_redraw()
	x_gridlines.queue_redraw()
	y_gridlines.queue_redraw()
	x_labels.queue_redraw()
	y_labels.queue_redraw()

func _update_margin():
	margin.bottom = _calculate_bottom_margin()
	margin.left = _calculate_left_margin()
	margin.right =  font_size/3 * (DigitCounter.get_max_num_digits(x_axis.min_value, x_axis.max_value) + decimal_places.x)

func _calculate_bottom_margin() -> float:
	var result = x_axis.tick_length if x_axis.num_ticks > 0 else 0.0
	result += font_size if x_labels.visible else 0.0
	result += thickness
	return result

func _calculate_left_margin(y_title_width : float = 0.0) -> float:
	var result = y_title_width
	result += y_axis.tick_length if y_axis.num_ticks > 0 else 0.0
	result += font_size if y_labels.visible else 0.0
	result += thickness
	result += font_size / 1.5 * (DigitCounter.get_max_num_digits(y_axis.min_value, y_axis.max_value) + decimal_places.y)
	result += y_title_margin
	return result

func _set_bottom_left_corner():
	bottom_left_corner.position = Vector2(margin.left, -margin.bottom + size.y)

func _set_axes_origin_positions_and_lengths():
	x_axis.origin = Vector2.UP * y_axis.get_zero_position_along_axis_clipped()
	y_axis.origin = Vector2.RIGHT * x_axis.get_zero_position_along_axis_clipped()
	
	x_axis.length = size.x - (margin.left + margin.right)
	y_axis.length = size.y - (margin.bottom + margin.top)

func get_axes_bottom_left_position() -> Vector2:
	return bottom_left_corner.position
