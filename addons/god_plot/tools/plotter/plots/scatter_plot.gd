class_name ScatterPlot extends Plot

var position : Vector2
var size : float
var shape : ScatterSeries.SHAPE
var filled : bool
var stroke : float

static var star_points : Array[Vector2] = _get_star_points_in_order()
static var triangle_points : Array[Vector2] = _get_triangle_points()
static var x_points : Array[Vector2] = _get_x_points_in_order()

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
		ScatterSeries.SHAPE.STAR:
			_draw_star(canvas_item)

func _draw_circle(canvas_item : CanvasItem) -> void:
	stroke = -1 if filled else stroke
	canvas_item.draw_circle(position, size, color, filled, stroke, true)

func _draw_square(canvas_item : CanvasItem) -> void:
	stroke = -1 if filled else stroke
	var top_left_corner = position - Vector2.ONE*size
	var rect = Rect2(top_left_corner, Vector2.ONE*size*2)
	canvas_item.draw_rect(rect, color, filled, stroke, true)

func _draw_triangle(canvas_item : CanvasItem) -> void:
	var triangle_corners = triangle_points.map(_apply_transformations)
	if filled:
		canvas_item.draw_colored_polygon(triangle_corners, color)
	else:
		canvas_item.draw_polyline(triangle_corners, color, stroke, true)

func _draw_x(canvas_item : CanvasItem) -> void:
	var x_points_in_order = x_points.map(_apply_transformations)
	canvas_item.draw_multiline(x_points_in_order, color, stroke, true)

func _draw_star(canvas_item : CanvasItem) -> void:
	var polygon = Array(star_points).map(_apply_transformations)
	if filled:
		canvas_item.draw_colored_polygon(polygon, color)
	else:
		canvas_item.draw_polyline(polygon, color, stroke, true)

func _apply_transformations(point : Vector2) -> Vector2:
	return point*size + position

static func _get_triangle_points() -> Array[Vector2]:
	const TRIANGLE_SCALE := 1.5
	var side_length : float = cos(PI/6.0) * 2.0 * TRIANGLE_SCALE 
	var top_point := Vector2.UP * TRIANGLE_SCALE
	var bottom_right := top_point + Vector2.RIGHT.rotated(PI/3.0)*side_length
	var bottom_left := top_point + Vector2.LEFT.rotated(-PI/3.0)*side_length
	var points : Array[Vector2] = []
	points.append(top_point)
	points.append(bottom_right)
	points.append(bottom_left)
	points.append(top_point)
	return points

static func _get_x_points_in_order() -> Array[Vector2]:
	return [
		-Vector2.ONE.normalized(),
		Vector2.ONE.normalized(),
		(Vector2.RIGHT + Vector2.UP).normalized(),
		(Vector2.LEFT + Vector2.DOWN).normalized(),
	]

static func _get_star_points_in_order() -> Array[Vector2]:
	const expanded_radius := 2.0
	const phase_shift := 3.0
	var result : Array[Vector2] = []
	for i in range(5):
		result.append(Vector2.UP.rotated(2*PI/5.0 * i) * expanded_radius)
		result.append(Vector2.DOWN.rotated(2*PI/5.0 * (i + phase_shift)))

	result.append(result[0])
	return result
