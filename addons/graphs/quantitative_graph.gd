@tool
class_name QuantitativeGraph extends Graph

## A node for creating scatter plots and line graphs.

@export_group("X Axis", "x_")
## Minimun value on X-axis
@export var x_min: float = 0.0:
	set(value):
		x_min = value
		if not is_inside_tree(): await ready
		%XAxis.min_value = value
		queue_redraw()
## Maximum value on X-axis
@export var x_max: float = 10.0:
	set(value):
		x_max = value
		if not is_inside_tree(): await ready
		%XAxis.max_value = value
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
		if not is_inside_tree(): await ready
		%XAxisTitle.text = value
## Number of ticks displayed on the x-axis. Includes border ticks.
@export var x_tick_count: int = 10:
	set(value):
		x_tick_count = value
		if not is_inside_tree(): await ready
		%XAxis.num_ticks = value
		queue_redraw()
## Show values on the ticks along the x-axis.
@export var x_tick_labels: bool = true:
	set(value):
		x_tick_labels = value
		queue_redraw()
## Shows the x-axis line.
@export var x_axis_thickness: float = 5:
	set(value):
		x_axis_thickness = value
		if not is_inside_tree(): await ready
		%XAxis.thickness = value
		queue_redraw()

@export_group("Y Axis", "y_")
## Minimun value on y-axis.
@export var y_min: float = 0.0:
	set(value):
		y_min = value
		if not is_inside_tree(): await ready
		%YAxis.min_value = value
		queue_redraw()
## Maximum value on y-axis.
@export var y_max: float = 10.0:
	set(value):
		y_max = value
		if not is_inside_tree(): await ready
		%YAxis.max_value = value
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
		if not is_inside_tree(): await ready
		%YAxisTitle.text = value
## Number of ticks displayed on the y-axis. Includes border ticks.
@export var y_tick_count: int = 10:
	set(value):
		y_tick_count = value
		if not is_inside_tree(): await ready
		%YAxis.num_ticks = value
		queue_redraw()
## Show values on the ticks along the y-axis.
@export var y_tick_labels: bool = true:
	set(value):
		y_tick_labels = value
		queue_redraw()
## Shows the y-axis line.
@export var y_axis_thickness: float = 5:
	set(value):
		y_axis_thickness = value
		if not is_inside_tree(): await ready
		%YAxis.thickness = value
		queue_redraw()

var series_arr : Array[QuantitativeSeries] = []

func _ready() -> void:
	for child in get_children():
		if child is QuantitativeSeries:
			series_arr.append(child)
			print("child appended")

	await get_tree().process_frame
	queue_redraw()

func _draw() -> void:
	update_margins()
	%XAxis.queue_redraw()
	%YAxis.queue_redraw()
	
func update_margins():
	var bottom_margin = %XAxis.tick_length * int(bool(x_tick_count))
	bottom_margin += get_theme_default_font_size() * int(x_tick_labels)
	bottom_margin += x_axis_thickness
	
	var left_margin = %YAxis.tick_length * int(bool(y_tick_count))
	left_margin += get_theme_default_font_size() * int(y_tick_labels)
	left_margin += y_axis_thickness
	left_margin += get_theme_default_font_size() / 2 * str(y_max).length()

	%XAxis.margin = Vector2(left_margin, -bottom_margin)
	%YAxis.margin = Vector2(left_margin, -bottom_margin)
	
	%XAxis.length = %ChartArea.size.x - (left_margin + get_theme_default_font_size()/2 * str(x_max).length())
	%YAxis.length = %ChartArea.size.y - (bottom_margin + get_theme_default_font_size()/2)
