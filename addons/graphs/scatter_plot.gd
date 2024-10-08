@tool
class_name ScatterPlot extends QuantitativeGraph

var series_arr : Array[QuantitativeSeries] = []
var to_draw := []

func _ready() -> void:
	super._ready()
	
	await get_tree().process_frame
	for child in get_children():
		if child is QuantitativeSeries:
			series_arr.append(child)
			child.property_changed.connect(queue_redraw)
			
	child_entered_tree.connect(on_child_entered)
	child_exiting_tree.connect(on_child_exiting)
	queue_redraw()

func on_child_entered(child : Node):
	if child is QuantitativeSeries:
		series_arr.append(child)
		child.property_changed.connect(queue_redraw)
	queue_redraw()
	
func on_child_exiting(child : Node):
	if child is QuantitativeSeries:
		series_arr.erase(child)
		child.property_changed.disconnect(queue_redraw)
	queue_redraw()

func add_series(type := QuantitativeSeries.TYPE.SCATTER, color := Color.BLUE, 
				display_size := 10.0) -> QuantitativeSeries:
	var series = QuantitativeSeries.new(type, color, display_size)
	add_child(series)
	return series

func plot_series(series : QuantitativeSeries) -> void:
	match series.type:
		QuantitativeSeries.TYPE.SCATTER: plot_scatter(series)
		QuantitativeSeries.TYPE.LINE: plot_line(series)
		QuantitativeSeries.TYPE.AREA: plot_area(series)

func plot_scatter(series : QuantitativeSeries) -> void:
	for point in series.data:
		if not is_within_limits(point): continue
		var point_position = find_point_global_position(point)
		to_draw.append([series.type, point_position, series.size, series.color])

func plot_line(series : QuantitativeSeries) -> void:
	if series.data.size() < 2:
		printerr("Line series must contain at least 2 data points")
		return
	var line : PackedVector2Array
	for point in series.data:
		if not is_within_limits(point): continue
		var point_position = find_point_global_position(point)
		line.append(point_position)
	to_draw.append([series.type, line, series.color, series.size])

func plot_area(series : QuantitativeSeries) -> void:
	var polygon : PackedVector2Array
	var first_x_coordinate := min_limits.x - 1.0
	var last_x_coordinate := min_limits.x - 1.0
	var zero_y = min(find_point_global_position(Vector2(0,0)).y, 
					 find_point_global_position(min_limits).y)
	var found_first := false
	for point in series.data:
		if not is_within_limits(point): continue
		var point_position = find_point_global_position(point)
		if !found_first:
			first_x_coordinate = point_position.x
			polygon.append(Vector2(point_position.x, zero_y))
			found_first = true
		polygon.append(point_position)
		last_x_coordinate = point_position.x

	if polygon.size() < 3: 
		printerr("Area series must contain at least 2 data points within the set limits")
		return
	polygon.append(Vector2(last_x_coordinate, zero_y))
	to_draw.append([series.type, polygon, series.color])
	
func find_point_global_position(point : Vector2) -> Vector2:
	var vector_from_local_origin = point - min_limits
	var position_from_origin = Vector2(vector_from_local_origin.x / range.x * x_axis.length,
								 	   -vector_from_local_origin.y / range.y * y_axis.length)
	return position_from_origin + global_origin
	
func scale_axes() -> void:
	var min_data_limits := Vector2(INF, INF)
	var max_data_limits := Vector2(-INF, -INF)
	for series in series_arr:
		for point in series.data:
			min_data_limits = min_data_limits.min(point)
			max_data_limits = max_data_limits.max(point)
	min_limits = min_data_limits.min(Vector2(x_min, y_min))
	max_limits = max_data_limits.max(Vector2(x_max, y_max))

func is_within_limits(point : Vector2) -> bool:
	return 	point.clamp(min_limits, max_limits) == point

func plot_points():
	to_draw = []
	for series in series_arr:
		plot_series(series)

func _draw() -> void:
	if auto_scaling: scale_axes()
	update_axes()
	plot_points()
	for point in to_draw:
		match point[0]:
			QuantitativeSeries.TYPE.SCATTER:
				draw_circle(point[1], point[2], point[3])
			QuantitativeSeries.TYPE.LINE:
				draw_polyline(point[1], point[2], point[3])
			QuantitativeSeries.TYPE.AREA:
				draw_colored_polygon(point[1], point[2])
