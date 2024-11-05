class_name ScatterPoint extends PlotData

var position : Vector2
var size : float

func _init(point_position : Vector2, point_color : Color, point_size : float) -> void:
	position = point_position
	color = point_color
	size = point_size

func draw_on(canvas_item : CanvasItem) -> void:
	canvas_item.draw_circle(position, size, color)
