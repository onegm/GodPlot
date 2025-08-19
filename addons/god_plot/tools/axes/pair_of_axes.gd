@tool
class_name PairOfAxes extends Control

var x_axis := Axis.new_x_axis()
var y_axis := Axis.new_y_axis()
var x_gridlines := Gridlines.new()
var y_gridlines := Gridlines.new()
var offset := Vector2.ZERO

var bottom_left_corner := DrawingAnchor.new()

var margin := {
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

var font_size : float = 16.0
var visible_tick_labels : bool = true

var decimal_places : Vector2i:
	set(value):
		decimal_places = value
		x_axis.decimal_places = decimal_places.x
		y_axis.decimal_places = decimal_places.y

func _ready() -> void:
	x_gridlines.set_origin_and_parallel_axes(x_axis, y_axis)
	y_gridlines.set_origin_and_parallel_axes(y_axis, x_axis)

	add_child(bottom_left_corner)
	bottom_left_corner.add_drawing_object(x_axis)
	bottom_left_corner.add_drawing_object(y_axis)
	bottom_left_corner.add_drawing_object(x_gridlines)
	bottom_left_corner.add_drawing_object(y_gridlines)

func get_min_values() -> Vector2: return Vector2(x_axis.min_value, y_axis.min_value)
	
func set_min_values(min_values : Vector2):
	x_axis.min_value = min_values.x
	y_axis.min_value = min_values.y
	
func get_max_values() -> Vector2: return Vector2(x_axis.max_value, y_axis.max_value)
	
func set_max_values(max_values : Vector2):
	x_axis.max_value = max_values.x
	y_axis.max_value = max_values.y

func get_range() -> Vector2:
	return Vector2(x_axis.get_range(), y_axis.get_range())

func _draw() -> void:
	update()
	bottom_left_corner.queue_redraw()
	
func update():
	_update_margins()
	_set_bottom_left_corner()
	_set_axes_offsets_and_lengths()

func _update_margins():
	_update_bottom_margin()
	_update_left_margin()
	_update_right_margin()
	

func _update_bottom_margin():
	var bottom_margin = x_axis.get_tick_length()
	bottom_margin += font_size if visible_tick_labels else 0.0
	bottom_margin += thickness
	bottom_margin += offset.y
	
	margin.bottom = bottom_margin

func _update_left_margin(y_title_width : float = 0.0):
	var left_margin = y_title_width
	left_margin += y_axis.get_tick_length()
	left_margin += font_size if visible_tick_labels else 0.0
	left_margin += thickness
	left_margin += font_size / 1.5 * (DigitCounter.get_max_num_digits(y_axis.min_value, y_axis.max_value) + decimal_places.y)
	left_margin += y_title_margin
	left_margin += offset.x
	
	margin.left = left_margin

func _update_right_margin():
	var max_digits_on_x_axis = DigitCounter.get_max_num_digits(x_axis.min_value, x_axis.max_value)
	margin.right =  font_size/3 * (max_digits_on_x_axis + decimal_places.x)

func _set_bottom_left_corner():
	bottom_left_corner.position = Vector2(margin.left, -margin.bottom + size.y)

func _set_axes_offsets_and_lengths():
	x_axis.offset = Vector2.UP * y_axis.get_zero_position_along_axis_clipped()
	y_axis.offset = Vector2.RIGHT * x_axis.get_zero_position_along_axis_clipped()
	
	var x_axis_length = size.x - (margin.left + margin.right)
	x_axis.length = max(0, x_axis_length)
	
	var y_axis_length = size.y - margin.bottom
	y_axis.length = max(0, y_axis_length)

func get_axes_bottom_left_position() -> Vector2:
	return bottom_left_corner.position

func get_pixel_position_from_minimum(vector_from_axes_minimum : Vector2) -> Vector2:
	return Vector2(
		x_axis.get_pixel_distance_from_minimum(vector_from_axes_minimum.x),
		-y_axis.get_pixel_distance_from_minimum(vector_from_axes_minimum.y),
		)

func set_font_and_size(font : FontFile, f_size : float):
	font_size = f_size
	x_axis.set_font_and_size(font, font_size)
	y_axis.set_font_and_size(font, font_size)

func set_num_ticks(num_vector : Vector2i):
	x_axis.set_num_ticks(num_vector.x)
	y_axis.set_num_ticks(num_vector.y)

func set_label_visibility(is_visible : bool):
	visible_tick_labels = is_visible
	x_axis.set_label_visibility(is_visible)
	y_axis.set_label_visibility(is_visible)
