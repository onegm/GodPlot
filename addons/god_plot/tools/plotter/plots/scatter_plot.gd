class_name ScatterPlot extends Plot

var position : Vector2
var size : float
var shape : ScatterSeries.SHAPE
var filled : bool
var stroke : float

func _init(point_position : Vector2, 
		point_color : Color, 
		point_size : float,
		point_shape : ScatterSeries.SHAPE,
		fill_shape : bool,
		outline_stroke : float
		) -> void:
	position = point_position
	color = point_color
	size = point_size
	shape = point_shape
	filled = fill_shape
	stroke = outline_stroke

static func from_scatter_series(point_position : Vector2, series : ScatterSeries) -> ScatterPlot:
	return ScatterPlot.new(
		point_position, 
		series.get_color(),
		series.get_size(),
		series.get_shape(),
		series.is_filled(),
		series.get_stroke()
	)

func draw_on(canvas_item : CanvasItem) -> void:
	match shape:
		ScatterSeries.SHAPE.CIRCLE:
			_draw_circle(canvas_item)
		ScatterSeries.SHAPE.SQUARE:
			_draw_square(canvas_item)
		ScatterSeries.SHAPE.TRIANGLE:
			_draw_triangle(canvas_item)
		ScatterSeries.SHAPE.X:
			_draw_x(canvas_item)

func _draw_circle(canvas_item : CanvasItem) -> void:
	canvas_item.draw_circle(position, size, color, filled, stroke, true)

func _draw_square(canvas_item : CanvasItem) -> void:
	var top_left_corner = position - Vector2.ONE*size
	var rect = Rect2(top_left_corner, Vector2.ONE*size*2)
	canvas_item.draw_rect(rect, color, filled, stroke, true)

func _draw_triangle(canvas_item : CanvasItem) -> void:
	var triangle_corners = _get_triangle_corners()
	if filled:
		canvas_item.draw_colored_polygon(triangle_corners, color)
	else:
		canvas_item.draw_polyline(triangle_corners, color, stroke, true)

func _get_triangle_corners() -> PackedVector2Array:
	var radius := size * 3/2.0
	var side_length : float = cos(PI/6.0) * radius * 2.0
	var top_point := position + Vector2.UP * radius
	var bottom_right := top_point + Vector2.RIGHT.rotated(PI/3.0)*side_length
	var bottom_left := top_point + Vector2.LEFT.rotated(-PI/3.0)*side_length
	var corners := PackedVector2Array()
	corners.append(top_point)
	corners.append(bottom_right)
	corners.append(bottom_left)
	corners.append(top_point)
	return corners

func _draw_x(canvas_item : CanvasItem) -> void:
	var top_left_corner := position - Vector2.ONE*size
	var x_positions_in_order = PackedVector2Array([
		top_left_corner, 
		top_left_corner + Vector2.ONE*size*2,
		top_left_corner + Vector2.RIGHT*size*2, 
		top_left_corner + Vector2.DOWN*size*2
	])
	canvas_item.draw_multiline(x_positions_in_order, color, stroke, true)
