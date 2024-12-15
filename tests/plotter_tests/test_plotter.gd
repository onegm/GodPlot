extends GutTest

var plotter : Graph2DPlotter
var axes : PairOfAxes

func before_all():
	axes = PairOfAxes.new()
	axes.set_global_position(Vector2.ZERO)
	axes.set_min_limits(Vector2(randi()%100 - 50, randi()%100 - 50))
	axes.set_max_limits(axes.get_min_limits() + Vector2(randi()%50, randi() %50))
	
	plotter = Graph2DPlotter.new()
	plotter.set_pair_of_axes(axes)
	plotter._update_axes_info()

func test_is_within_limits_true_for_axes_limits():
	assert_true(plotter.is_within_limits(axes.get_min_limits()))
	assert_true(plotter.is_within_limits(axes.get_max_limits()))

func test_is_within_limits_false_for_outside():
	assert_false(plotter.is_within_limits(axes.get_min_limits() - Vector2(1, 0)))
	assert_false(plotter.is_within_limits(axes.get_min_limits() - Vector2(0, 1)))
	assert_false(plotter.is_within_limits(axes.get_max_limits() + Vector2(1, 0)))
	assert_false(plotter.is_within_limits(axes.get_max_limits() + Vector2(1, 0)))

func test_find_local_position():
	axes.set_min_limits(Vector2.ZERO)
	axes.set_max_limits(Vector2.ONE*10)
	plotter._update_axes_info()
	assert_eq(plotter.find_point_local_position(Vector2.ZERO), Vector2.ZERO)
	assert_eq(plotter.find_point_local_position(Vector2.ONE*5), Vector2(250, -250))
	assert_eq(plotter.find_point_local_position(Vector2(3, 7)), Vector2(150, -350))

func test_find_y_position_of_area_base_when_min_is_greater_than_zero():
	axes.set_min_limits(Vector2.ONE * 5)
	axes.set_max_limits(Vector2.ONE*10)
	plotter._update_axes_info()
	var base_y : float = plotter.find_y_position_of_area_base()
	var bottom_edge_y : float = plotter.find_point_local_position(axes.get_min_limits()).y
	assert_eq(bottom_edge_y, base_y)

func test_find_y_position_of_area_base_when_max_is_less_than_zero():
	axes.set_min_limits(Vector2.ONE * -10)
	axes.set_max_limits(Vector2.ONE * -5)
	plotter._update_axes_info()
	var base_y : float = plotter.find_y_position_of_area_base()
	var top_edge_y : float = plotter.find_point_local_position(axes.get_max_limits()).y
	assert_eq(top_edge_y, base_y)

func test_find_y_position_of_area_base_when_zero_is_within_limits():
	axes.set_min_limits(Vector2.ONE * -5)
	axes.set_max_limits(Vector2.ONE * 7)
	plotter._update_axes_info()
	var base_y : float = plotter.find_y_position_of_area_base()
	var zero_y : float = plotter.find_point_local_position(Vector2.ZERO).y
	assert_eq(zero_y, base_y)

func after_all():
	plotter.free()
	axes.free()

	
