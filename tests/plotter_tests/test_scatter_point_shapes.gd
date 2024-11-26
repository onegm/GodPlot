extends GutTest

func test_get_triangle_points():
	var triangle_points : Array[Vector2] = ScatterPointShapes.TRIANGLE
	var expected = [
		Vector2.UP * 1.5,
		Vector2(1.299038, 0.75),
		Vector2(-1.299038, 0.75),
		Vector2.UP * 1.5
	]
	assert_eq(triangle_points.size(), expected.size())
	for i in range(expected.size()):
		assert_almost_eq(triangle_points[i], expected[i], Vector2.ONE*0.00001)

func test_get_star_points_in_order():
	var star_points : Array[Vector2] = ScatterPointShapes.STAR
	var expected = [
		Vector2(0, -2),
		Vector2(0.587785, -0.809017),
		Vector2(1.902113, -0.618034),
		Vector2(0.951056, 0.309017),
		Vector2(1.17557, 1.618034),
		Vector2(0, 1),
		Vector2(-1.175571, 1.618034),
		Vector2(-0.951057, 0.309017),
		Vector2(-1.902113, -0.618034),
		Vector2(-0.587785, -0.809017),
		Vector2(0, -2)
	]
	assert_eq(star_points.size(), expected.size())
	for i in range(expected.size()):
		assert_almost_eq(star_points[i], expected[i], Vector2.ONE*0.00001)

func test_get_x_points_in_order():
	var x_points : Array[Vector2] = ScatterPointShapes.X
	var expected = [
		Vector2(-1, -1).normalized(),
		Vector2(1, 1).normalized(),
		Vector2(1, -1).normalized(),
		Vector2(-1, 1).normalized(),
	]
	assert_eq(x_points.size(), expected.size())
	for i in range(expected.size()):
		assert_almost_eq(x_points[i], expected[i], Vector2.ONE*0.00001)
