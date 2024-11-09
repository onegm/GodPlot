class_name PairOfAxes extends Control

var bottom_left_corner := Vector2.ZERO
var x_axis := Axis.new_x_axis()
var y_axis := Axis.new_y_axis()
var graph : Graph
var origin := Vector2.ZERO
var margin := {
	"top" : 0.0,
	"left": 0.0,
	"right": 0.0,
	"bottom": 0.0
	}

enum ORIGIN_POSITION {FLOATING, BOTTOM_LEFT, TOP_LEFT, CENTER, BOTTOM_RIGHT, TOP_RIGHT}
var origin_position := ORIGIN_POSITION.FLOATING

func _init(containing_graph : Graph) -> void:
	graph = containing_graph
	graph.draw.connect(queue_redraw)
	
func _ready() -> void:
	for axis in [x_axis, y_axis]:
		add_child(axis)
		axis.color = Color.DEEP_PINK
		axis.show_tick_labels = true
		axis.min_value = -15.0
		axis.max_value = 0.0

func _update_margin():
	margin.bottom = x_axis.tick_length if x_axis.num_ticks > 0 else 0.0
	margin.bottom += x_axis.font_size if x_axis.show_tick_labels else 0.0
	margin.bottom += x_axis.thickness
	
	margin.left = y_axis.tick_length if y_axis.num_ticks > 0 else 0.0
	margin.left += y_axis.font_size if y_axis.show_tick_labels else 0.0
	margin.left += y_axis.thickness
	margin.left += y_axis.font_size / 1.5 * (max(get_num_digits(y_axis.max_value), get_num_digits(y_axis.min_value)) + graph.y_decimal_places)
	
	margin.right =  x_axis.font_size/3 * (get_num_digits(x_axis.max_value) + graph.x_decimal_places)
	
	margin.left += graph._get_y_axis_title_width()
	margin.top = graph._get_graph_title_height() / 2

static func get_num_digits(num : float) -> int:
	num = abs(num)
	return floor(log(num)/log(10)) if num > 0 else 1

func _update_axes_origin_and_length():
	x_axis.origin = Vector2(margin.left, -margin.bottom)
	y_axis.origin = Vector2(margin.left, -margin.bottom)
	x_axis.length = graph.chart_area.size.x - (margin.left + margin.right)
	y_axis.length = graph.chart_area.size.y - (margin.bottom + margin.top)
	
func set_origin_position():
	x_axis.origin += Vector2.UP * y_axis.get_zero_position_clipped()
	y_axis.origin += Vector2.RIGHT * x_axis.get_zero_position_clipped()

func _draw() -> void:
	_update_margin()
	_update_axes_origin_and_length()
	set_origin_position()
	
	x_axis.queue_redraw()
	y_axis.queue_redraw()
