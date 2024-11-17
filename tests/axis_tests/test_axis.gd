extends GutTest

var axis : Axis

func before_all():
	axis = Axis.new()

func before_each():
	axis.min_value = 0
	axis.max_value = 10
	axis.length = 100

func test_new_x_axis():
	var x_axis : Axis = autofree(Axis.new_x_axis())
	assert_false(x_axis.is_vertical)

func test_new_y_axis():
	var y_axis : Axis = autofree(Axis.new_y_axis())
	assert_true(y_axis.is_vertical)

func test_update_tick_interval():
	axis.num_ticks = 10
	assert_eq(axis.tick_interval/axis.get_range(), 1.0)
	axis.num_ticks = 2
	assert_eq(axis.tick_interval/axis.get_range(), 5.0)

func test_update_tick_interval_with_decimals():
	axis.decimal_places = 0
	axis.num_ticks = 4
	assert_eq(axis.tick_interval/axis.get_range(), 3.0)
	axis.decimal_places = 1
	axis._update_tick_interval()
	assert_eq(axis.tick_interval/axis.get_range(), 2.5)

func test_get_zero_position_when_zero_is_minimum():
	assert_eq(axis.get_zero_position_along_axis_clipped(), 0.0)

func test_get_zero_position_when_zero_is_in_middle_of_range():
	axis.min_value = -10.0
	assert_eq(axis.get_zero_position_along_axis_clipped(), 50.0)
	
func test_get_zero_position_when_zero_is_greater_than_maximum():
	axis.min_value = -10.0
	axis.max_value = -5.0
	assert_eq(axis.get_zero_position_along_axis_clipped(), 100.0)
