extends GutTest

var plotter : Plotter
var graph : Graph2D

func before_all():
	graph = Graph2D.new()
	graph.set_global_position(Vector2.ZERO)
	graph.min_limits = Vector2(randi()%100 - 50, randi()%100 - 50)
	graph.max_limits = graph.min_limits + Vector2(randi()%50, randi() %50)
	
	plotter = Plotter.new(graph)

func test_is_within_limits_true_for_graph_limits():
	assert_true(plotter.is_within_limits(graph.min_limits))
	assert_true(plotter.is_within_limits(graph.max_limits))

func test_is_within_limits_false_for_outside():
	assert_false(plotter.is_within_limits(graph.min_limits - Vector2(1, 0)))
	assert_false(plotter.is_within_limits(graph.min_limits - Vector2(0, 1)))
	assert_false(plotter.is_within_limits(graph.max_limits + Vector2(1, 0)))
	assert_false(plotter.is_within_limits(graph.max_limits + Vector2(1, 0)))

func test_find_local_position():
	graph.min_limits = Vector2.ZERO
	graph.max_limits = Vector2.ONE*10
	assert_eq(plotter.find_point_local_position(Vector2.ZERO), Vector2(3, 0))
	assert_eq(plotter.find_point_local_position(Vector2.ONE*5), Vector2(252.25, -249.25))
	assert_eq(plotter.find_point_local_position(Vector2(3, 7)), Vector2(152.55, -348.95))


func after_all():
	plotter.free()
	graph.free()

	
