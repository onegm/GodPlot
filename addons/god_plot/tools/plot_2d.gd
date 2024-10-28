@tool
class_name Plot2D extends QuantitativeGraph

## Plotter class used with [QuantitativeSeries] to plot data on a 2D graph.
## Automatically plots any [QuantitativeSeries] children nodes in the same order of the scene tree. 

## Typed array of [QuantitativeSeries] nodes to be plotted on the graph 
var series_arr : Array[QuantitativeSeries] = []
## Plotter object used for plotting data
var plotter : Plotter = Plotter.new(self)

func _ready() -> void:
	super._ready()
	chart_area.add_child(plotter)
	plotter.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	await get_tree().process_frame
	_load_children_series()
	child_order_changed.connect(_load_children_series)
	queue_redraw()

func _load_children_series():
	## Checks children for [QuantitativeSeries] nodes and loads them into [member series_arr].
	## Connects each child's [signal QuantitativeSeries.property_changed]
	## signal to [method Control.queue_redraw].
	series_arr = []
	for child in get_children().filter(func(s): return s is QuantitativeSeries):	
		series_arr.append(child)
		if !child.property_changed.is_connected(queue_redraw):
			child.property_changed.connect(queue_redraw)
	queue_redraw()

## Dynamically creates a [QuantitativeSeries] node and adds it as child. A [QuantitativeSeries] 
## node can be added manually in the editor instead. 
## Returns [QuantitativeSeries] object in which data can be loaded. See [method QuantitativeSeries.add_point].
func add_series(type := QuantitativeSeries.TYPE.SCATTER, color := Color.BLUE, 
				display_size := 10.0) -> QuantitativeSeries:
	var series = QuantitativeSeries.new(type, color, display_size)
	add_child(series)
	return series
	
## Removes a [QuantitativeSeries] from the plot.
func remove_series(series : QuantitativeSeries):
	remove_child(series)

## Maps a [Vector2] point from graph coordinates to local coordinates.
func find_point_local_postion(point : Vector2) -> Vector2:
	var vector_from_local_origin = point - min_limits
	var position_from_origin = Vector2(vector_from_local_origin.x / range.x * x_axis.length,
								 	   -vector_from_local_origin.y / range.y * y_axis.length)
	return position_from_origin + x_axis.origin
	
func _scale_axes() -> void:
	## Only runs if [constant QuantitativeGraph.auto_scaling] is enabled. Finds maximum and minimum
	## values in current data and scales axes to fit all points. Will never increase the value of [member x_min] or 
	## decrease the value of [member x_max]. Same goes for the y_axis.
	var min_data_limits := Vector2(INF, INF)
	var max_data_limits := Vector2(-INF, -INF)
	for series in series_arr:
		for point in series.data:
			min_data_limits = min_data_limits.min(point)
			max_data_limits = max_data_limits.max(point)
	min_limits = min_data_limits.min(Vector2(x_min, y_min))
	max_limits = max_data_limits.max(Vector2(x_max, y_max))

## Checks if a [Vector2] point is within graph limits.
func is_within_limits(point : Vector2) -> bool:
	return 	point.clamp(min_limits, max_limits) == point
	
func _plot_points():
	for series in series_arr:
		plotter._plot_series(series)

## Clears all data in all [QuantitativeSeries] children of this node.
func clear():
	for series in series_arr:
		series.clear()

func _draw() -> void:
	if auto_scaling: _scale_axes()
	super._draw()
	_plot_points()
	plotter.queue_redraw()
