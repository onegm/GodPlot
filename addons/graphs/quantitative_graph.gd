@tool
class_name QuantitativeGraph extends Graph

## A node for creating scatter plots and line graphs.

@export_group("X Axis", "x_")
## Minimun value on X-axis
@export var x_min: float = 0.0:
	set(value):
		x_min = value
		range.x = x_max - x_min
		queue_redraw()
## Maximum value on X-axis
@export var x_max: float = 10.0:
	set(value):
		x_max = value
		range.x = x_max - x_min
		queue_redraw()
## Allows [member x_max] and [member x_min] to dynamically change to accomodate new data points.
@export var x_auto_scaling : bool = true:
	set(value):
		x_auto_scaling = value
@export_subgroup("Display", "x_")
## Title of x-axis
@export var x_title: String = "":
	set(value):
		x_title = value
		queue_redraw()
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
## Minimun value on y-axis.
@export var y_min: float = 0.0:
	set(value):
		y_min = value
		range.y = y_max - y_min
		queue_redraw()
## Maximum value on y-axis.
@export var y_max: float = 10.0:
	set(value):
		y_max = value
		range.y = y_max - y_min
		queue_redraw()
## Allows [member y_max] and [member y_min] to dynamically change to accomodate new data points.
@export var y_auto_scaling : bool = true:
	set(value):
		y_auto_scaling = value
@export_subgroup("Display", "y_")
## Title of y-axis.
@export var y_title: String = "":
	set(value):
		y_title = value
		queue_redraw()
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
	x_axis_title.text = x_title 
	x_axis.min_value = x_min
	x_axis.max_value = x_max
	x_axis.num_ticks = x_tick_count
	x_axis.show_tick_labels = x_tick_labels
	x_axis.decimal_places = x_decimal_places
	x_axis.thickness = x_axis_thickness
	
	y_axis_title.text = y_title
	y_axis.min_value = y_min
	y_axis.max_value = y_max
	y_axis.num_ticks = y_tick_count
	y_axis.show_tick_labels = y_tick_labels
	y_axis.decimal_places = y_decimal_places
	y_axis.thickness = y_axis_thickness
	
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
