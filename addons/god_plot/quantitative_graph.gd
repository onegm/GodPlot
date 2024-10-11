@tool
class_name QuantitativeGraph extends Graph

## A base node for creating two-dimensional quantitative graphs (see inherited by). 
## Cannot be used to plot data but will display a 2D graph with the associated display controls. 
## Use [Plot2D] for a graph with plotting capabilities.

## Color of both axes.
@export var axes_color : Color = Color.BLACK:
	set(value):
		axes_color = value
		queue_redraw()
## Font size multiplier applied to axis labels.
@export_range(0, 5) var label_size : float = 1.0:
	set(value):
		label_size = value
		_on_theme_changed()
## Allows ([member x_min], [member x_max]) and ([member y_min], [member y_max]) to dynamically change 
## to fit all data points. If not enabled, points lying outside the limits will be clipped.
@export var auto_scaling : bool = true:
	set(value):
		auto_scaling = value
		queue_redraw()
@export_group("X Axis", "x_")
## Minimun value on X-axis. Can be automatically decreased if auto-scaling is enabled. 
@export var x_min: float = 0.0:
	set(value):
		x_min = value
		if x_min > x_max: x_max = x_min
		queue_redraw()
## Maximum value on X-axis. Can be overriden if auto-scaling is enabled.
@export var x_max: float = 10.0:
	set(value):
		x_max = value
		if x_max < x_min: x_min = x_max
		queue_redraw()
@export_subgroup("Display", "x_")
## Number of ticks displayed on the x-axis.
@export var x_tick_count: int = 10:
	set(value):
		x_tick_count = value
		queue_redraw()
## Show values on the ticks along the x-axis.
@export var x_tick_labels: bool = true:
	set(value):
		x_tick_labels = value
		queue_redraw()
## Number of decimal places shown on the x-axis tick labels.
@export_range(0, 5) var x_decimal_places : int = 1:
	set(value):
		x_decimal_places = value
		queue_redraw()
## Sets thickness of the x-axis line.
@export var x_axis_thickness: float = 5:
	set(value):
		x_axis_thickness = value
		queue_redraw()

@export_group("Y Axis", "y_")
## Minimun value on y-axis. Can be overriden if auto-scaling is enabled.
@export var y_min: float = 0.0:
	set(value):
		y_min = value
		if y_min > y_max: y_max = y_min
		queue_redraw()
## Maximum value on y-axis. Can be overriden if auto-scaling is enabled.
@export var y_max: float = 10.0:
	set(value):
		y_max = value
		if y_max < y_min: y_min = y_max
		queue_redraw()
@export_subgroup("Display", "y_")
## Number of ticks displayed on the y-axis.
@export var y_tick_count: int = 10:
	set(value):
		y_tick_count = value
		queue_redraw()
## Show values on the ticks along the y-axis.
@export var y_tick_labels: bool = true:
	set(value):
		y_tick_labels = value
		queue_redraw()
## Number of decimal places shown on the y-axis tick labels.
@export_range(0, 5) var y_decimal_places : int = 1:
	set(value):
		y_decimal_places = value
		queue_redraw()
## Sets thickness of the x-axis line.
@export var y_axis_thickness: float = 5:
	set(value):
		y_axis_thickness = value
		queue_redraw()
## The minimum values of the x and y axes stored as a [Vector2]. Should be equal to 
## [constructor Vector2(x_min, y_min)] unless [member auto_scaling] is enabled. 
var min_limits := Vector2(x_min, y_min) : 
	set(value):
		min_limits = value
		range = Vector2(max_limits.x - min_limits.x, max_limits.y - min_limits.y)
## The maximum values of the x and y axes stored as a [Vector2]. Should be equal to 
## [constructor Vector2(x_max, y_max)] unless [member auto_scaling] is enabled. 
var max_limits := Vector2(x_max, y_max):
	set(value):
		max_limits = value
		range = Vector2(max_limits.x - min_limits.x, max_limits.y - min_limits.y)
## The difference between the maximum and minimum values on the x and y axes stored
## as a [Vector2]
var range := Vector2(x_max - x_min, y_max - y_min)
## An [Axis] object used as the horizontal axis of the graph
var x_axis := Axis.new()
## An [Axis] object used as the vertical axis of the graph
var y_axis := Axis.new()
## The global position of the graph's origin
var global_origin_position := x_axis.global_position + x_axis.origin

func _ready() -> void:
	super._ready()
	chart_area.add_child(x_axis)
	chart_area.add_child(y_axis)
	x_axis.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	y_axis.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	y_axis.is_vertical = true
	
	await get_tree().process_frame
	queue_redraw()

func _update_limits() -> void:	
	## Updates the values of [member min_limits] and [member max_limits] based on
	## the state of [member auto_scaling].
	if auto_scaling:
		max_limits = max_limits.max(Vector2(x_max, y_max))
		min_limits = min_limits.min(Vector2(x_min, y_min))
	else:
		min_limits = Vector2(x_min, y_min)
		max_limits = Vector2(x_max, y_max)

func _update_axes() -> void:
	## Updates the properties of [member x_axis] and [member y_axis].
	if not is_inside_tree(): await ready
	x_axis.min_value = min_limits.x
	x_axis.max_value = max_limits.x
	x_axis.num_ticks = x_tick_count
	x_axis.show_tick_labels = x_tick_labels
	x_axis.decimal_places = x_decimal_places
	x_axis.thickness = x_axis_thickness
	x_axis.color = axes_color
	
	y_axis.min_value = min_limits.y
	y_axis.max_value = max_limits.y
	y_axis.num_ticks = y_tick_count
	y_axis.show_tick_labels = y_tick_labels
	y_axis.decimal_places = y_decimal_places
	y_axis.thickness = y_axis_thickness
	y_axis.color = axes_color
	
func _update_margins():
	## Update margins keeping drawings within the chart area. 
	var bottom_margin = x_axis.tick_length * int(bool(x_tick_count))
	bottom_margin += get_theme_font_size("", "") * label_size * int(x_tick_labels)
	bottom_margin += x_axis_thickness
	
	var left_margin = y_axis.tick_length * int(bool(y_tick_count))
	left_margin += get_theme_font_size("", "") * label_size * int(y_tick_labels)
	left_margin += y_axis_thickness
	left_margin += get_theme_font_size("", "") * label_size / 2 * (floor(log(abs(y_max))) + y_decimal_places)

	x_axis.origin = Vector2(left_margin, -bottom_margin)
	y_axis.origin = Vector2(left_margin, -bottom_margin)
	
	var right_margin =  get_theme_font_size("", "") * label_size/3 * (floor(log(abs(x_max))) + x_decimal_places)
	var top_margin = get_theme_font_size("", "") * title_size / 2
	x_axis.length = chart_area.size.x - (left_margin + right_margin)
	y_axis.length = chart_area.size.y - (bottom_margin + top_margin)

## Returns the pixel length of the x and y axis drawings a [Vector2].
func get_axes_lengths() -> Vector2:
	return Vector2(x_axis.length, y_axis.length)

func _draw() -> void:
	_update_limits()
	_update_axes()
	_update_margins()
	
	x_axis.queue_redraw()
	y_axis.queue_redraw()
	
	global_origin_position = x_axis.global_position + x_axis.origin
	
func _on_theme_changed():
	super._on_theme_changed()
	await get_tree().process_frame
	x_axis.font_size = get_theme_font_size("", "") * label_size
	y_axis.font_size = get_theme_font_size("", "") * label_size
	queue_redraw()
