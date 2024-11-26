class_name ScatterPointShapes

static var STAR : Array[Vector2] = get_star_points_in_order()
static var TRIANGLE : Array[Vector2] = get_triangle_points()
static var X : Array[Vector2] = get_x_points_in_order()

static func get_triangle_points() -> Array[Vector2]:
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

static func get_x_points_in_order() -> Array[Vector2]:
	return [
		-Vector2.ONE.normalized(),
		Vector2.ONE.normalized(),
		(Vector2.RIGHT + Vector2.UP).normalized(),
		(Vector2.LEFT + Vector2.DOWN).normalized(),
	]

static func get_star_points_in_order() -> Array[Vector2]:
	const expanded_radius := 2.0
	const phase_shift := 3.0
	var result : Array[Vector2] = []
	for i in range(5):
		result.append(Vector2.UP.rotated(2*PI/5.0 * i) * expanded_radius)
		result.append(Vector2.DOWN.rotated(2*PI/5.0 * (i + phase_shift)))

	result.append(result[0])
	return result
