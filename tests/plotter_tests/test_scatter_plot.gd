extends GutTest

var scatter_plot : ScatterPlot

func before_all():
	scatter_plot = ScatterPlot.new(
		Vector2(15, 19), 
		Color.BLUE, 
		5.0, 
		ScatterSeries.SHAPE.CIRCLE,
		true, 
		2.0
		)

func test_apply_transformations():
	var result = scatter_plot._apply_transformations(Vector2.ONE)
	assert_eq(result, Vector2(20, 24))

func test_get_triangle_points():
	var triangle_points = ScatterPlot._get_triangle_points()
	var expected_result = [
		Vector2.UP * 1.5,
		Vector2(1.299038, 0.75),
		Vector2(-1.299038, 0.75),
		Vector2.UP * 1.5
	]
	assert_eq(triangle_points.size(), expected_result.size())
	for i in range(expected_result.size()):
		assert_almost_eq(triangle_points[i], expected_result[i], Vector2.ONE*0.00001)

func test_get_star_points_in_order():
	var star_points = ScatterPlot._get_star_points_in_order()
	var expected_result = [
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
	assert_eq(star_points.size(), expected_result.size())
	for i in range(expected_result.size()):
		assert_almost_eq(star_points[i], expected_result[i], Vector2.ONE*0.00001)
