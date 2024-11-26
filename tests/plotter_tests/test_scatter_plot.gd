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
