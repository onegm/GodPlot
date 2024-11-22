class_name AxisTicks extends CanDraw

var axis : Axis
var interval : float = 0.0
var length : float = 10.0
var positions_along_axis : Array[float] = []
var canvas : CanvasItem

func _init(axis_to_mark : Axis):
	axis = axis_to_mark

func draw_on(canvas_item : CanvasItem):
	if axis.num_ticks <= 0: return
	canvas = canvas_item
	_update_properties()
	_draw_ticks()

func _update_properties():
	length = 2.0 * axis.thickness
	_update_interval()
	_update_tick_positions()

func _update_interval():
	var tick_value_interval =  axis.get_range() / float(axis.num_ticks)
	var rounded_value_interval = Rounder.round_num_to_decimal_place(tick_value_interval, axis.decimal_places)
	interval = remap(rounded_value_interval, 0, axis.get_range(), 0, axis.length)

func _update_tick_positions():
	positions_along_axis.clear()
	if is_zero_approx(interval): 
		return
	var zero_position = axis.get_zero_position_along_axis_clipped()
	var position : float = zero_position
	
	while position < axis.length or is_equal_approx(position, axis.length):
		positions_along_axis.append(position)
		position += interval
	
	position = zero_position - interval
	while position >= 0:
		positions_along_axis.append(position)
		position -= interval
		
	positions_along_axis.sort()

func _draw_ticks():
	var vector_positions = positions_along_axis.map(_convert_to_vector_position)
	for position in vector_positions:
		_draw_tick(position)

func _convert_to_vector_position(position : float):
	return position * axis.direction + axis.offset

func _draw_tick(start : Vector2):
	canvas.draw_line(
		start - length * axis.out_direction , 
		start + length * axis.out_direction,
		axis.color, axis.thickness / 3
		)
