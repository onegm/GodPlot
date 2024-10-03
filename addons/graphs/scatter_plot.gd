@tool
class_name ScatterPlot extends QuantitativeGraph

var series_arr : Array[QuantitativeSeries] = []
var to_draw := []

func _ready() -> void:
	super._ready()
	for child in get_children():
		if child is QuantitativeSeries:
			series_arr.append(child)
	queue_redraw()

func plot_series(series : QuantitativeSeries):
	var range : Vector2 = get_range()
	var length : Vector2 = get_axes_lengths()
	var origin_on_screen : Vector2 = get_origin_on_screen()
	for point in series.data:
		var vector_from_origin = (point - Vector2(x_min, y_min)) 
		var point_position = Vector2(vector_from_origin.x / range.x * length.x,
									 -vector_from_origin.y / range.y * length.y)
		point_position += origin_on_screen
		to_draw.append([point_position, series.size, series.color])
	
func _draw() -> void:
	super._draw()
	draw_circle(Vector2(400, 400), 20.0, Color.RED)
	for series in series_arr:
		plot_series(series)
	for point in to_draw:
		draw_circle(point[0], point[1], point[2])
		print(point)
	to_draw = []
