class_name Gridlines extends CanDraw

var color : Color
var major_thickness : float = 1.0
var minor_thickness : float = 1.0
var minor_count : int = 0:
	set(value):
		minor_count = maxi(0, value)
## The axis from which the gridlines are drawn. The major gridlines will match the ticks on that axis.
var origin_axis : Axis
## The axis parallel to the gridlines. The gridlines will match the length of this axis.
var parallel_axis : Axis

var minor_interval : float:
	set(value):
		minor_interval = abs(value)

var major_gridline_positions : Array[Vector2] = []

func _init() -> void:
	pass

func set_origin_and_parallel_axes(origin : Axis, parallel : Axis):
	origin_axis = origin
	parallel_axis = parallel

func draw_on(canvas : CanvasItem) -> void:
	draw_major_gridlines(canvas)
	draw_minor_gridlines(canvas)

func draw_major_gridlines(canvas : CanvasItem):
	_set_major_gridline_positions()
	for major_pos in major_gridline_positions:
		canvas.draw_line(
			major_pos,
			major_pos - parallel_axis.length * origin_axis.out_direction,
			color, major_thickness
			)

func _set_major_gridline_positions():
	major_gridline_positions.clear()
	for tick_position in origin_axis.get_tick_positions_along_axis():
		major_gridline_positions.append(tick_position * origin_axis.direction)

func draw_minor_gridlines(canvas : CanvasItem):
	if !minor_count:
		return
	_update_minor_interval()
	if is_zero_approx(minor_interval):
		return
	var first_minor_position = get_first_minor_position()
	
	var minor_gridline_position = first_minor_position
	var graph_edge = origin_axis.length * origin_axis.direction
	while minor_gridline_position < graph_edge:
		canvas.draw_line(
			minor_gridline_position,
			minor_gridline_position - parallel_axis.length * origin_axis.out_direction, 
			color, minor_thickness
		)
		minor_gridline_position += minor_interval * origin_axis.direction

func _update_minor_interval():
	minor_interval = origin_axis.get_tick_interval() / float(minor_count + 1)	

func get_first_minor_position() -> Vector2:
	var first_minor_position = major_gridline_positions[0]
	var smallest_remaining_gap = minor_interval * origin_axis.direction
	while first_minor_position > smallest_remaining_gap or first_minor_position.is_equal_approx(smallest_remaining_gap):
		first_minor_position -= minor_interval * origin_axis.direction
	return first_minor_position
