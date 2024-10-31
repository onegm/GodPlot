@tool
class_name Graph2D extends Graph
## A node for creating two-dimensional quantitative graphs. 
## Used with [Series] to plot data on a 2D graph. 
## Automatically plots any [Series] children nodes in the same order of the scene tree. 

## Series container
var series_container : SeriesContainer

func _ready() -> void:
	super._ready()
	series_container = SeriesContainer.new(self)
	add_child(series_container)

func _draw() -> void:
	_update_axes_limits()
	super._draw()
	for series in series_container.get_all_series():
		plotter._load_drawing_positions(series)
	plotter.queue_redraw()

func _update_axes_limits() -> void:
	min_limits = Vector2(x_min, y_min)
	max_limits = Vector2(x_max, y_max)
	
	if auto_scaling:
		min_limits = series_container.get_min_values().min(min_limits)
		max_limits = series_container.get_max_values().max(max_limits)
		
	x_axis.min_value = min_limits.x
	x_axis.max_value = max_limits.x
	y_axis.min_value = min_limits.y
	y_axis.max_value = max_limits.y
