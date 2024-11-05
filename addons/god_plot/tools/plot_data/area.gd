class_name Area extends PlotData

var polygon_points := PackedVector2Array()

func _init(area_color : Color) -> void:
	color = area_color

func add_point(point : Vector2):
	if !polygon_points.has(point):
		polygon_points.append(point)

func draw_on(canvas_item : CanvasItem) -> void:
	var doesnt_have_enough_points_to_draw_area = polygon_points.size() < 3
	if doesnt_have_enough_points_to_draw_area: 
		return
	var poly_array = Geometry2D.merge_polygons(polygon_points, PackedVector2Array([]))
	for piece in poly_array:
		canvas_item.draw_colored_polygon(piece, color)
