@tool
class_name Axis extends Control

var is_vertical : bool = false: 
	set(value):
		is_vertical = value
		direction = Vector2.UP if is_vertical else Vector2.RIGHT
		out_direction = Vector2.LEFT if is_vertical else Vector2.DOWN
var min_value : float = 0
var max_value : float = 10
var length : float = 500.0:
	set(value):
		length = max(0, value)
		_update_tick_interval()

var thickness : float = 3.0:
	set(value):
		thickness = max(0, value)
		tick_length = 2 * thickness

var color : Color = Color.WHITE

var num_ticks : int = 10:
	set(value):
		num_ticks = max(0, value)
		_update_tick_interval()

var origin : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.RIGHT
var out_direction : Vector2 = Vector2.DOWN

var tick_interval : float = 0.0
var tick_length : float = 10.0
var tick_positions_along_axis : Array[float] = []
var tick_positions : Array[Vector2] = []
var decimal_places : int = 2

static func new_x_axis() -> Axis:
	return Axis.new()

static func new_y_axis() -> Axis:
	var axis = Axis.new()
	axis.is_vertical = true
	return axis

func _draw() -> void:
	draw_circle(origin, thickness/2, color)
	draw_line(origin, origin + length * direction, color, thickness)
	draw_circle(origin + length * direction, thickness/2, color)
	_draw_ticks()
	
func _draw_ticks() -> void:
	if num_ticks <= 0: return
	_update_tick_interval()
	_update_tick_positions()
	for tick_position in tick_positions:
		_draw_tick(tick_position)

func _update_tick_interval():
	var tick_value_interval =  get_range() / float(num_ticks + 1) if num_ticks else 0
	var rounded_value_interval = Rounder.round_num_to_decimal_place(tick_value_interval, decimal_places)
	tick_interval = remap(rounded_value_interval, 0, get_range(), 0, length)

func _update_tick_positions():
	tick_positions_along_axis.clear()
	var zero_position = get_zero_position_clipped()
	var tick_position : float = zero_position
	while tick_position <= length:
		tick_positions_along_axis.append(tick_position)
		tick_position += tick_interval
	
	tick_position = zero_position - tick_interval
	while tick_position >= 0:
		tick_positions_along_axis.append(tick_position)
		tick_position -= tick_interval
		
	tick_positions_along_axis.sort()
	_set_vector_tick_positions()
	
func get_zero_position_clipped() -> float:
	if min_value >= 0:
		return 0.0
	if max_value <= 0:
		return length
	else:
		return (0.0 - min_value) / get_range() * length

func get_range() -> float:
	return max_value - min_value
	
func _set_vector_tick_positions():
	tick_positions.clear()
	for tick_position in tick_positions_along_axis:
		var vector_tick_position = tick_position * direction + origin
		tick_positions.append(vector_tick_position)

func _draw_tick(start : Vector2):
	draw_line(
		start - tick_length * out_direction , 
		start + tick_length * out_direction,
		color, thickness / 3
		)

func get_label_values_at_ticks() -> Array[float]:
	var tick_values : Array[float] = []
	var range := get_range()
	for tick_position in tick_positions_along_axis:
		var value = min_value + tick_position / length * range
		tick_values.append(value)
	return tick_values
