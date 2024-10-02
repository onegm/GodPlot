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
## Allows [member x_max] and [member x_min] to dynamically change to accomodate new data points.
@export var x_auto_scaling : bool = true:
	set(value):
		x_auto_scaling = value
@export_subgroup("Display", "x_")
## Title of x-axis
@export var x_title: String = "":
	set(value):
		x_title = value
## Number of ticks displayed on the x-axis. Includes border ticks.
@export var x_tick_count: int = 0:
	set(value):
		x_tick_count = value
## Show values on the ticks along the x-axis.
@export var x_tick_labels: bool = true:
	set(value):
		x_tick_labels = value
## Shows the x-axis line.
@export var x_show_axis: bool = true:
	set(value):
		x_show_axis = value

@export_group("Y Axis", "y_")
## Minimun value on y-axis.
@export var y_min: float = 0.0:
	set(value):
		y_min = value
## Maximum value on y-axis.
@export var y_max: float = 10.0:
	set(value):
		y_max = value
## Allows [member y_max] and [member y_min] to dynamically change to accomodate new data points.
@export var y_auto_scaling : bool = true:
	set(value):
		y_auto_scaling = value
@export_subgroup("Display", "y_")
## Title of y-axis.
@export var y_title: String = "":
	set(value):
		y_title = value
## Number of ticks displayed on the y-axis. Includes border ticks.
@export var y_tick_count: int = 0:
	set(value):
		y_tick_count = value
## Show values on the ticks along the y-axis.
@export var y_tick_labels: bool = true:
	set(value):
		y_tick_labels = value
## Shows the y-axis line.
@export var y_show_axis: bool = true:
	set(value):
		y_show_axis = value

var series_arr : Array[QuantitativeSeries] = []

func _ready() -> void:
	for child in get_children():
		if child is QuantitativeSeries:
			series_arr.append(child)
			print("child appended")
