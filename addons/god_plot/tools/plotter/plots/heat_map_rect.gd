class_name HeatMapRect extends Plot

var position : Vector2
var size : Vector2

func _init(rect_position : Vector2, 
		rect_color : Color, 
		rect_size : Vector2,
		) -> void:
	position = rect_position
	color = rect_color
	size = rect_size

func draw_on(canvas_item : CanvasItem) -> void:
	_draw_rect(canvas_item)

func _draw_rect(canvas_item : CanvasItem) -> void:
	var top_left_corner = position - Vector2(0, size.y)
	var rect = Rect2(top_left_corner, Vector2.ONE*size)
	canvas_item.draw_rect(rect, color, true, -1, true)
