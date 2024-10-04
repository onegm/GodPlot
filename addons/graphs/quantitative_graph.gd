@tool
class_name QuantitativeGraph extends Graph

## A node for creating scatter plots, line graphs, or area graphs.

## Color of both axes.
@export var axes_color : Color = Color.BLACK:
	set(value):
		axes_color = value
		queue_redraw()
## Allows ([member x_min], [member x_max]) and ([member y_min], [member y_max]) to dynamically change to accomodate new data points.
@export var auto_scaling : bool = true:
	set(value):
		auto_scaling = value
		if not auto_scaling:
			min_limits = Vector2(x_min, y_min)
			max_limits = Vector2(x_max, y_max)
		queue_redraw()
@export_group("X Axis", "x_")
## Minimun value on X-axis. Can be overriden if auto-scaling is set to true.
@export var x_min: float = 0.0:
	set(value):
		x_min = value
		min_limits = Vector2(x_min, y_min)
		queue_redraw()
## Maximum value on X-axis. Can be overriden if auto-scaling is set to true.
@export var x_max: float = 10.0:
	set(value):
		x_max = value
		max_limits = Vector2(x_max, y_max)
		queue_redraw()
@export_subgroup("Display", "x_")
## Number of ticks displayed on the x-axis. Includes border ticks.
@export var x_tick_count: int = 10:
	set(value):
		x_tick_count = value
		queue_redraw()
## Show values on the ticks along the x-axis.
@export var x_tick_labels: bool = true:
	set(value):
		x_tick_labels = value
		queue_redraw()
@export var x_decimal_places : int = 1:
	set(value):
		x_decimal_places = value
		queue_redraw()
## Shows the x-axis line.
@export var x_axis_thickness: float = 5:
	set(value):
		x_axis_thickness = value
		queue_redraw()

@export_group("Y Axis", "y_")
## Minimun value on y-axis. Can be overriden if auto-scaling is set to true.
@export var y_min: float = 0.0:
	set(value):
		y_min = value
		min_limits = Vector2(x_min, y_min)
		queue_redraw()
## Maximum value on y-axis. Can be overriden if auto-scaling is set to true.
@export var y_max: float = 10.0:
	set(value):
		y_max = value
		max_limits = Vector2(x_max, y_max)
		queue_redraw()
@export_subgroup("Display", "y_")
## Number of ticks displayed on the y-axis. Includes border ticks.
@export var y_tick_count: int = 10:
	set(value):
		y_tick_count = value
		queue_redraw()
## Show values on the ticks along the y-axis.
@export var y_tick_labels: bool = true:
	set(value):
		y_tick_labels = value
		queue_redraw()
@export var y_decimal_places : int = 1:
	set(value):
		y_decimal_places = value
		queue_redraw()
## Shows the y-axis line.
@export var y_axis_thickness: float = 5:
	set(value):
		y_axis_thickness = value
		queue_redraw()

var min_limits := Vector2(x_min, y_min) : 
	set(value):
		min_limits = value
		range = Vector2(max_limits.x - min_limits.x, max_limits.y - min_limits.y)
var max_limits := Vector2(x_max, y_max):
	set(value):
		max_limits = value
		range = Vector2(max_limits.x - min_limits.x, max_limits.y - min_limits.y)
var range := Vector2(x_max - x_min, y_max - y_min)
var x_axis := Axis.new()
var y_axis := Axis.new()

func _ready() -> void:
	super._ready()
	chart_area.add_child(x_axis)
	chart_area.add_child(y_axis)
	x_axis.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	y_axis.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	y_axis.is_vertical = true
	
	await get_tree().process_frame
	queue_redraw()
	
func _draw() -> void:
	if not is_inside_tree(): await ready
	update_axes()
	update_margins()
	x_axis.queue_redraw()
	y_axis.queue_redraw()

func update_axes() -> void:
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
	
func update_margins():
	var bottom_margin = x_axis.tick_length * int(bool(x_tick_count))
	bottom_margin += get_theme_default_font_size() * int(x_tick_labels)
	bottom_margin += x_axis_thickness
	
	var left_margin = y_axis.tick_length * int(bool(y_tick_count))
	left_margin += get_theme_default_font_size() * int(y_tick_labels)
	left_margin += y_axis_thickness
	left_margin += get_theme_default_font_size() / 2 * (floor(log(abs(y_max))) + y_decimal_places)

	x_axis.origin = Vector2(left_margin, -bottom_margin)
	y_axis.origin = Vector2(left_margin, -bottom_margin)
	
	var right_margin =  get_theme_default_font_size()/3 * (floor(log(abs(x_max))) + x_decimal_places)
	var top_margin = get_theme_default_font_size()/2
	x_axis.length = chart_area.size.x - (left_margin + right_margin)
	y_axis.length = chart_area.size.y - (bottom_margin + top_margin)

func get_origin_on_screen() -> Vector2:
	return x_axis.global_position + x_axis.origin
func get_axes_lengths() -> Vector2:
	return Vector2(x_axis.length, y_axis.length)
