@tool
class_name QuantitativeGraph extends Graph

## A node for creating scatter plots and line graphs.

@export_group("X Axis", "x_")
## Minimun value on X-axis
@export var x_min: float = 0.0:
	set(value):
		x_min = value
		queue_redraw()
## Maximum value on X-axis
@export var x_max: float = 10.0:
	set(value):
		x_max = value
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
@export var x_decimal_places : int = 0:
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
		queue_redraw()
## Maximum value on y-axis.
@export var y_max: float = 10.0:
	set(value):
		y_max = value
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
@export var y_decimal_places : int = 0:
	set(value):
		y_decimal_places = value
		queue_redraw()
## Shows the y-axis line.
@export var y_axis_thickness: float = 5:
	set(value):
		y_axis_thickness = value
		queue_redraw()

func _ready() -> void:
	await get_tree().process_frame
	queue_redraw()
	
func _draw() -> void:
	if not is_inside_tree(): await ready
	update_axes()
	update_margins()
	%XAxis.queue_redraw()
	%YAxis.queue_redraw()

func update_axes() -> void:
	%XAxisTitle.text = x_title 
	%XAxis.min_value = x_min
	%XAxis.max_value = x_max
	%XAxis.num_ticks = x_tick_count
	%XAxis.show_tick_labels = x_tick_labels
	%XAxis.decimal_places = x_decimal_places
	%XAxis.thickness = x_axis_thickness
	
	%YAxisTitle.text = y_title
	%YAxis.min_value = y_min
	%YAxis.max_value = y_max
	%YAxis.num_ticks = y_tick_count
	%YAxis.show_tick_labels = y_tick_labels
	%YAxis.decimal_places = y_decimal_places
	%YAxis.thickness = y_axis_thickness
	
func update_margins():
	var bottom_margin = %XAxis.tick_length * int(bool(x_tick_count))
	bottom_margin += get_theme_default_font_size() * int(x_tick_labels)
	bottom_margin += x_axis_thickness
	
	var left_margin = %YAxis.tick_length * int(bool(y_tick_count))
	left_margin += get_theme_default_font_size() * int(y_tick_labels)
	left_margin += y_axis_thickness
	left_margin += get_theme_default_font_size() / 2 * (str(y_max).length() + y_decimal_places)

	%XAxis.origin = Vector2(left_margin, -bottom_margin)
	%YAxis.origin = Vector2(left_margin, -bottom_margin)
	
	var right_margin =  get_theme_default_font_size()/3 * (str(x_max).length() + x_decimal_places)
	var top_margin = get_theme_default_font_size()/2
	%XAxis.length = %ChartArea.size.x - (left_margin + right_margin)
	%YAxis.length = %ChartArea.size.y - (bottom_margin + top_margin)
