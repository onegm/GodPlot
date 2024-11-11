@tool
class_name Axis extends Control
## Class used to draw a custom axis. 

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
## The pixel thickness of the axis.
var thickness : float = 3.0:
	set(value):
		thickness = max(0, value)
		tick_length = 2 * thickness
## The color of the axis and its ticks.
var color : Color = Color.WHITE
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
	for i in range(num_ticks + 1):
		var start = origin + (thickness / 2  + tick_interval * i) * direction
		draw_line(start - tick_length * out_direction , start + tick_length * out_direction,
				  color, thickness / 3)

func _update_tick_interval():
	tick_interval = (length - thickness) / float(num_ticks) if num_ticks else 0

func get_zero_position_clipped() -> float:
	if min_value >= 0:
		return 0.0
	if max_value <= 0:
		return length
	else:
		return (0.0 - min_value) / (max_value - min_value) * length

func get_range() -> float:
	return max_value - min_value

func get_value_at_each_tick() -> Array[float]:
	var tick_values : Array[float] = []
	var range := get_range()
	for tick in (num_ticks + 1):
		tick_values.append(min_value + range/num_ticks * tick)
	return tick_values
