extends GutTest

var axis : Axis

func before_all():
	axis = Axis.new()

func before_each():
	axis.min_value = 0
	axis.max_value = 10
	axis.length = 100
	axis.set_num_ticks(10)
	axis.axis_ticks._update_properties()

func test_new_x_axis():
	var x_axis : Axis = autofree(Axis.new_x_axis())
	assert_false(x_axis.is_vertical)

func test_new_y_axis():
	var y_axis : Axis = autofree(Axis.new_y_axis())
	assert_true(y_axis.is_vertical)

func test_get_range():
	assert_eq(axis.get_range(), 10.0)
	axis.min_value = -5
	assert_eq(axis.get_range(), 15.0)

func test_get_zero_position_when_zero_is_minimum():
	assert_eq(axis.get_zero_position_along_axis_clipped(), 0.0)

func test_get_zero_position_when_zero_is_in_middle_of_range():
	axis.min_value = -10.0
	assert_eq(axis.get_zero_position_along_axis_clipped(), axis.length/2.0)
	
func test_get_zero_position_when_zero_is_greater_than_maximum():
	axis.min_value = -10.0
	axis.max_value = -5.0
	assert_eq(axis.get_zero_position_along_axis_clipped(), axis.length)

func test_get_tick_positions_along_axis():
	var result = axis.get_tick_positions_along_axis()
	var expected : Array[float] = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100] 
	assert_eq(result, expected)

func test_get_label_values_at_ticks():
	var result = axis.get_label_values_at_ticks()
	var expected : Array[float] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
	assert_eq(result, expected)

func test_get_pixel_distance_from_minimum():
	var zero = axis.get_pixel_distance_from_minimum(0)
	var fifty = axis.get_pixel_distance_from_minimum(5)
	var seventy_five = axis.get_pixel_distance_from_minimum(7.5)
	
	assert_eq(zero, 0.0)
	assert_eq(fifty, 50.0)
	assert_eq(seventy_five, 75.0)
