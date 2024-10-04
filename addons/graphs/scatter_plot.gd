@tool
class_name ScatterPlot extends QuantitativeGraph

var series_arr : Array[QuantitativeSeries] = []
var to_draw := []

func _ready() -> void:
	super._ready()
	for child in get_children().duplicate():
		if child is QuantitativeSeries:
			series_arr.append(child)
			child.property_changed.connect(queue_redraw)
	queue_redraw()

func plot_series(series : QuantitativeSeries) -> void:
	match series.type:
		QuantitativeSeries.TYPE.SCATTER: plot_scatter(series)
		QuantitativeSeries.TYPE.LINE: plot_line(series)
		QuantitativeSeries.TYPE.AREA: plot_area(series)

func plot_scatter(series : QuantitativeSeries) -> void:
	var length : Vector2 = get_axes_lengths()
	var origin_on_screen : Vector2 = get_origin_on_screen()
	for point in series.data:
		var vector_from_origin = (point - Vector2(x_min, y_min)) 
		var point_position = Vector2(vector_from_origin.x / range.x * length.x,
									 -vector_from_origin.y / range.y * length.y)
		point_position += origin_on_screen
		to_draw.append([series.type, point_position, series.size, series.color])

func plot_line(series : QuantitativeSeries) -> void:
	var length : Vector2 = get_axes_lengths()
	var origin_on_screen : Vector2 = get_origin_on_screen()
	var line : PackedVector2Array
	for point in series.data:
		var vector_from_origin = (point - Vector2(x_min, y_min)) 
		var point_position = Vector2(vector_from_origin.x / range.x * length.x,
									 -vector_from_origin.y / range.y * length.y)
		point_position += origin_on_screen
		line.append(point_position)
	to_draw.append([series.type, line, series.color, series.size])


func plot_area(series : QuantitativeSeries) -> void:
	var length : Vector2 = get_axes_lengths()
	var origin_on_screen : Vector2 = get_origin_on_screen()
	var polygon : PackedVector2Array
	polygon.append(origin_on_screen)
	var last_x_coordinate = 0.0
	for point in series.data:
		var vector_from_origin = (point - Vector2(x_min, y_min)) 
		var point_position = Vector2(vector_from_origin.x / range.x * length.x,
									 -vector_from_origin.y / range.y * length.y)
		point_position += origin_on_screen
		polygon.append(point_position)
		last_x_coordinate = point_position.x
	polygon.append(Vector2(last_x_coordinate, origin_on_screen.y))
	to_draw.append([series.type, polygon, series.color])
	
func _draw() -> void:
	super._draw()
	draw_circle(Vector2(400, 400), 20.0, Color.RED)
	draw_circle(Vector2(0, 0), 20.0, Color.RED)
	for series in series_arr:
		plot_series(series)
	for point in to_draw:
		match point[0]:
			QuantitativeSeries.TYPE.SCATTER:
				draw_circle(point[1], point[2], point[3])
			QuantitativeSeries.TYPE.LINE:
				draw_polyline(point[1], point[2], point[3])
			QuantitativeSeries.TYPE.AREA:
				draw_colored_polygon(point[1], point[2])

	to_draw = []
