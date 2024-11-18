@tool
class_name Axis extends Control

var is_vertical : bool = false: 
	set(value):
		is_vertical = value
		direction = Vector2.UP if is_vertical else Vector2.RIGHT
		out_direction = Vector2.LEFT if is_vertical else Vector2.DOWN

var min_value : float = 0:
	set(value):
		min_value = Rounder.floor_num_to_decimal_place(value, decimal_places)

var max_value : float = 10:
	set(value):
		max_value = Rounder.ceil_num_to_decimal_place(value, decimal_places)

var length : float = 500.0

var thickness : float = 3.0

var color : Color = Color.WHITE
var offset : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.RIGHT
var out_direction : Vector2 = Vector2.DOWN
var decimal_places : int = 2

var axis_ticks := AxisTicks.new(self)
var num_ticks : int = 10

var axis_labels := AxisLabels.new(self)
var font_size :float = 16.0
var visible_labels := true

static func new_x_axis() -> Axis:
	return Axis.new()

static func new_y_axis() -> Axis:
	var axis = Axis.new()
	axis.is_vertical = true
	return axis

func _draw() -> void:
	_draw_axis()
	axis_ticks.draw()
	axis_labels.draw()

func _draw_axis():	
	draw_circle(offset, thickness/2, color)
	draw_line(offset, offset + length * direction, color, thickness)
	draw_circle(offset + length * direction, thickness/2, color)
	
func get_range() -> float:
	return max_value - min_value

func get_zero_position_along_axis_clipped() -> float:
	if min_value >= 0:
		return 0.0
	if max_value <= 0:
		return length
	else:
		return (0.0 - min_value) / get_range() * length

func get_label_values_at_ticks() -> Array[float]:
	var tick_values : Array[float] = []
	var range := get_range()
	for tick_position in get_tick_positions_along_axis():
		var value = min_value + tick_position / length * range
		tick_values.append(value)
	return tick_values

func get_tick_positions_along_axis() -> Array[float]:
	return axis_ticks.positions_along_axis

func get_tick_length() -> float:
	return axis_ticks.length

func get_value_interval() -> float:
	return get_range()/float(num_ticks)
