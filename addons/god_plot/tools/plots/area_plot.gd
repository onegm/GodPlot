class_name AreaPlot extends Plot

var polygon_points := PackedVector2Array()

func _init(area_color : Color) -> void:
	color = area_color

func add_point(point : Vector2):
	if !polygon_points.has(point):
		polygon_points.append(point)

func draw_on(canvas_item : CanvasItem) -> void:
	var polygon_arr = Geometry2D.merge_polygons(polygon_points, PackedVector2Array([]))

	for piece in polygon_arr.filter(has_atleast_4_points):
		canvas_item.draw_colored_polygon(piece, color)

func has_atleast_4_points(packed_array : PackedVector2Array) -> bool:
	return packed_array.size() >= 4
