@tool
class_name Plot2D extends QuantitativeGraph

## Plotter class used with [QuantitativeSeries] to plot data on a 2D graph.
## Automatically plots any [QuantitativeSeries] children nodes in the same order of the scene tree. 

## Typed array of [QuantitativeSeries] nodes to be plotted on the graph 
var series_arr : Array[QuantitativeSeries] = []
## Plotter object used for plotting data
var plotter : Plotter = Plotter.new()
## Array of items to be drawn in global coordinates.
var to_draw := []

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

func _plot_series(series : QuantitativeSeries) -> void:
	## Populates the [member to_draw] array using the given [QuantitativeSeries] parameter.
	match series.type:
		QuantitativeSeries.TYPE.SCATTER: _plot_scatter(series)
		QuantitativeSeries.TYPE.LINE: _plot_line(series)
		QuantitativeSeries.TYPE.AREA: _plot_area(series)

func _plot_scatter(series : QuantitativeSeries) -> void:
	## This method is called by [method _plot_series] on all [QuantitativeSeries] nodes with type 
	## [constant QuantitativeSeries.TYPE.SCATTER]. All points in the series will be mapped to global coordinates
	## and appended to [member to_draw] along with color and size information.
	for point in series.data:
		if not is_within_limits(point): continue
		var point_position = find_point_local_postion(point)
		to_draw.append([series.type, point_position, series.size, series.color])

func _plot_line(series : QuantitativeSeries) -> void:
	## This method is called by [method _plot_series] on all [QuantitativeSeries] nodes with type 
	## [constant QuantitativeSeries.TYPE.LINE]. All points in the series will be mapped to global coordinates
	## and appended to [member to_draw] as a [PackedVector2Array] along with color and size information.
	## Must include a minimum of two data points to be plotted. Points must be within bounds unless 
	## [constant QuantitativeGraph.auto_scaling] is enabled.
	if series.data.size() < 2: return
	var line : PackedVector2Array
	for point in series.data:
		if not is_within_limits(point): continue
		var point_position = find_point_local_postion(point)
		line.append(point_position)
	to_draw.append([series.type, line, series.color, series.size])

func _plot_area(series : QuantitativeSeries) -> void:
	## This method is called by [method _plot_series] on all [QuantitativeSeries] nodes with type 
	## [constant QuantitativeSeries.TYPE.AREA]. All points in the series will be mapped to global coordinates
	## and appended to [member to_draw] as an array of [PackedVector2Array]s along with color information.
	## Must include a minimum of two data points to be plotted. Points must be within bounds unless 
	## [constant QuantitativeGraph.auto_scaling] is enabled.
	var polygon : PackedVector2Array
	var first_x_coordinate := min_limits.x - 1.0
	var last_x_coordinate := min_limits.x - 1.0
	var zero_y = min(find_point_local_postion(Vector2(0,0)).y, 
					 find_point_local_postion(min_limits).y)
	var found_first := false
	for point in series.data:
		if not is_within_limits(point): continue
		var point_position = find_point_local_postion(point)
		if !found_first:
			first_x_coordinate = point_position.x
			polygon.append(Vector2(point_position.x, zero_y))
			found_first = true
		polygon.append(point_position)
		last_x_coordinate = point_position.x
		
	if polygon.size() < 3: return
	polygon.append(Vector2(last_x_coordinate, zero_y))
	var poly_array = Geometry2D.merge_polygons(polygon, PackedVector2Array([]))
	for piece in poly_array:
		to_draw.append([series.type, piece, series.color])

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
	## Resets the [member to_draw] array and calls [method _plot_series] on each data series in
	## [member series_arr]
	to_draw = []
	for series in series_arr:
		_plot_series(series)

## Clears all data in all [QuantitativeSeries] children of this node.
func clear():
	for series in series_arr:
		series.clear()

func _draw() -> void:
	if auto_scaling: _scale_axes()
	super._draw()
	_plot_points()
	plotter.to_draw = to_draw
	plotter.queue_redraw()
