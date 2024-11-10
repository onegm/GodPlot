class_name PairOfAxes extends Control

var x_axis := Axis.new_x_axis()
var y_axis := Axis.new_y_axis()
var x_gridlines := Gridlines.new(x_axis, y_axis)
var y_gridlines := Gridlines.new(y_axis, x_axis)
var graph : Graph

var min_limits : Vector2: 
	set(value):
		min_limits = value
		range = Vector2(max_limits.x - min_limits.x, max_limits.y - min_limits.y)
var max_limits : Vector2:
	set(value):
		max_limits = value
		range = Vector2(max_limits.x - min_limits.x, max_limits.y - min_limits.y)
var range : Vector2

var margin := {
	"top" : 0.0,
	"left": 0.0,
	"right": 0.0,
	"bottom": 0.0
	}

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

func _init(containing_graph : Graph) -> void:
	graph = containing_graph
	graph.draw.connect(queue_redraw)
	
	min_limits = Vector2(graph.x_min, graph.y_min)
	max_limits = Vector2(graph.x_max, graph.y_max)
	
func _ready() -> void:
	for axis in [x_axis, y_axis]:
		add_child(axis)
		axis.color = Color.DEEP_PINK
		axis.show_tick_labels = true
		axis.min_value = -15.0
		axis.max_value = 0.0
	add_child(x_gridlines)
	add_child(y_gridlines)


static func get_num_digits(num : float) -> int:
	num = abs(num)
	return floor(log(num)/log(10)) if num > 0 else 1

func set_origin_position():
	x_axis.origin += Vector2.UP * y_axis.get_zero_position_clipped()
	y_axis.origin += Vector2.RIGHT * x_axis.get_zero_position_clipped()

func get_min_limits() -> Vector2:
	return Vector2(x_axis.min_value, y_axis.min_value)
func set_min_limits(min_limits : Vector2):
	x_axis.min_value = min_limits.x
	y_axis.min_value = min_limits.y
func get_max_limits() -> Vector2:
	return Vector2(x_axis.max_value, y_axis.max_value)
func set_max_limits(max_limits : Vector2):
	x_axis.max_value = max_limits.x
	y_axis.max_value = max_limits.y

func get_range() -> Vector2:
	return Vector2(x_axis.max_value - x_axis.min_value, y_axis.max_value - y_axis.min_value)
	
func _draw() -> void:
	_update_margin()
	_update_axes_origin_and_length()
	set_origin_position()
	
	x_axis.queue_redraw()
	y_axis.queue_redraw()
	x_gridlines.queue_redraw()
	y_gridlines.queue_redraw()

func _update_margin():
	margin.bottom = x_axis.tick_length if x_axis.num_ticks > 0 else 0.0
	margin.bottom += font_size if x_axis.show_tick_labels else 0.0
	margin.bottom += thickness
	
	margin.left = y_axis.tick_length if y_axis.num_ticks > 0 else 0.0
	margin.left += font_size if y_axis.show_tick_labels else 0.0
	margin.left += thickness
	margin.left += font_size / 1.5 * (max(get_num_digits(y_axis.max_value), get_num_digits(y_axis.min_value)) + graph.y_decimal_places)
	
	margin.right =  font_size/3 * (get_num_digits(x_axis.max_value) + graph.x_decimal_places)
	
	margin.left += graph.get_y_axis_title_width()
	margin.top = graph.get_graph_title_height() / 2

func _update_axes_origin_and_length():
	x_axis.origin = Vector2(margin.left, -margin.bottom)
	y_axis.origin = Vector2(margin.left, -margin.bottom)
	x_axis.length = graph.chart_area.size.x - (margin.left + margin.right)
	y_axis.length = graph.chart_area.size.y - (margin.bottom + margin.top)
	
