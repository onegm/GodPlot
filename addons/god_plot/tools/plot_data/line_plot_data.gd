class_name LinePlotData extends PlotData

var points := PackedVector2Array()
var thickness : float

func _init(line_color : Color, line_thickness : float) -> void:
	color = line_color
	thickness = line_thickness

func add_point(point : Vector2):
	if !points.has(point):
		points.append(point)

func draw_on(canvas_item : CanvasItem) -> void:
	var doesnt_have_enough_points_to_draw_a_line = points.size() < 2
	if doesnt_have_enough_points_to_draw_a_line: 
		return
	canvas_item.draw_polyline(points, color, thickness, true)
