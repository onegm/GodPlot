extends GutTest

var plotter : Plotter
var axes : PairOfAxes

func before_all():
	axes = PairOfAxes.new()
	axes.set_global_position(Vector2.ZERO)
	axes.set_min_limits(Vector2(randi()%100 - 50, randi()%100 - 50))
	axes.set_max_limits(axes.get_min_limits() + Vector2(randi()%50, randi() %50))
	
	plotter = Plotter.new(axes)
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


func after_all():
	plotter.free()
	axes.free()

	
