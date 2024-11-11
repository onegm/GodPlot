class_name PairOfAxes extends Control

var x_axis := Axis.new_x_axis()
var y_axis := Axis.new_y_axis()
var x_gridlines := Gridlines.new(x_axis, y_axis)
var y_gridlines := Gridlines.new(y_axis, x_axis)

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
		x_axis.font_size = font_size
		y_axis.font_size = font_size

var num_ticks : Vector2i:
	set(value):
		num_ticks = value
		x_axis.num_ticks = num_ticks.x
		y_axis.num_ticks = num_ticks.y

var visible_tick_labels : bool:
	set(value):
		visible_tick_labels = value
		x_axis.show_tick_labels = visible_tick_labels
		y_axis.show_tick_labels = visible_tick_labels

var decimal_places : Vector2i:
	set(value):
		decimal_places = value
		x_axis.decimal_places = decimal_places.x
		y_axis.decimal_places = decimal_places.y	
	
func _ready() -> void:
	for axis in [x_axis, y_axis]:
		add_child(axis)
		axis.color = Color.DEEP_PINK
		axis.show_tick_labels = true
		axis.min_value = -15.0
		axis.max_value = 0.0
	add_child(x_gridlines)
	add_child(y_gridlines)

func get_min_limits() -> Vector2: return Vector2(x_axis.min_value, y_axis.min_value)
	
func set_min_limits(min_limits : Vector2):
	x_axis.min_value = min_limits.x
	y_axis.min_value = min_limits.y
	
func get_max_limits() -> Vector2: return Vector2(x_axis.max_value, y_axis.max_value)
	
func set_max_limits(max_limits : Vector2):
	x_axis.max_value = max_limits.x
	y_axis.max_value = max_limits.y
	
func get_range() -> Vector2:
	return Vector2(x_axis.max_value - x_axis.min_value, y_axis.max_value - y_axis.min_value)
	
func _draw() -> void:
	_update_margin()
	_set_axes_margins()
	_set_origin_position()
	
	x_axis.queue_redraw()
	y_axis.queue_redraw()
	x_gridlines.queue_redraw()
	y_gridlines.queue_redraw()

func _update_margin():
	margin.bottom = _calculate_bottom_margin()
	margin.left = _calculate_left_margin()
	margin.right =  font_size/3 * (get_num_digits(x_axis.max_value) + x_axis.decimal_places)

func _calculate_bottom_margin() -> float:
	var result = x_axis.tick_length if x_axis.num_ticks > 0 else 0.0
	result += font_size if x_axis.show_tick_labels else 0.0
	result += thickness
	return result

func _calculate_left_margin(y_title_width : float = 0.0) -> float:
	var result = y_title_width
	result += y_axis.tick_length if y_axis.num_ticks > 0 else 0.0
	result += font_size if y_axis.show_tick_labels else 0.0
	result += thickness
	result += font_size / 1.5 * (max(get_num_digits(y_axis.max_value), get_num_digits(y_axis.min_value)) + y_axis.decimal_places)
	result += y_title_margin
	return result

static func get_num_digits(num : float) -> int:
	num = abs(num)
	return floor(log(num)/log(10)) if num > 0 else 1

func _set_axes_margins():
	x_axis.origin = Vector2(margin.left, -margin.bottom + size.y)
	x_gridlines.origin = Vector2(margin.left, -margin.bottom + size.y)
	
	y_axis.origin = Vector2(margin.left, -margin.bottom + size.y)
	y_gridlines.origin = Vector2(margin.left, -margin.bottom + size.y)
	
	x_axis.length = size.x - (margin.left + margin.right)
	y_axis.length = size.y - (margin.bottom + margin.top)

func _set_origin_position():
	x_axis.origin += Vector2.UP * y_axis.get_zero_position_clipped()
	y_axis.origin += Vector2.RIGHT * x_axis.get_zero_position_clipped()

func get_axes_bottom_left_position() -> Vector2:
	return Vector2(margin.left, -margin.bottom)
