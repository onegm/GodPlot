extends GutTest

var series : HistogramSeries
var data : Array[float]

func before_each():
	data = [
		7, 10, 2, 22.5, 83, 25, -52, 30, 31, 65, 99
	]
	series = autofree(HistogramSeries.new())
	series.x_min = 0.0
	series.bin_size = 10.0
	series.set_data(data)

func test_clear():
	series.clear_data()
	assert_true(series.data.size() == 0)

func test_set_data_sorts_data():
	series.clear_data()
	series.set_data(data)
	data.sort()
	assert_eq(series.data, data)

func test_add_point_sorts_data():
	var point_to_add = 50
	series.add_point(point_to_add)
	data.append(point_to_add)
	data.sort()

	assert_eq(series.data, data)

func test_add_point_bins_data():
	var point_to_add = 50
	series.add_point(point_to_add)
	var expected = {
		-6 : 1,
		0 : 2,
		1 : 1,
		2 : 2,
		3 : 2,
		5 : 1,
		6 : 1,
		8 : 1,
		9 : 1
	}
	assert_eq(series.binned_data, expected)

func test_remove_point_that_exists():
	var index = randi() % series.data.size()
	
	var expected = series.data.duplicate()
	expected.remove_at(index)
	
	var point_to_remove = series.data[index]
	series.remove_point(point_to_remove)
	
	assert_eq(series.data, expected)

func test_remove_point_that_does_not_exist():
	var point_to_remove = 1234
	var expected = series.data.duplicate()
	assert_does_not_have(series.data, point_to_remove)
	series.remove_point(point_to_remove)
	assert_eq(series.data, expected)

func test_bin_data():
	series.x_min = 0
	var expected = {
		-6 : 1,
		0 : 2,
		1 : 1,
		2 : 2,
		3 : 2,
		6 : 1,
		8 : 1,
		9 : 1
	}
	var binned_data = series._bin_data()
	
	assert_eq(binned_data, expected)

func test_get_bin_num():
	assert_eq(series.get_bin_num(0), 0)
	assert_eq(series.get_bin_num(9), 0)
	assert_eq(series.get_bin_num(10), 1)
	assert_eq(series.get_bin_num(124), 12)

func test_get_bin_num_with_negative_bins():
	assert_eq(series.get_bin_num(-5), -1)
	assert_eq(series.get_bin_num(-12), -2)

func test_get_bin_num_with_different_x_min():
	series.x_min = 25
	series.bin_size = 25
	assert_eq(series.get_bin_num(9), -1)
	assert_eq(series.get_bin_num(25), 0)
	assert_eq(series.get_bin_num(49), 0)
	assert_eq(series.get_bin_num(50), 1)
	assert_eq(series.get_bin_num(100), 3)

func test_increment_bin_num_with_new_bin():
	series.binned_data.clear()
	series._increment_bin_num(0)
	series._increment_bin_num(5)
	
	var expected = {
		0 : 1,
		5 : 1
	}
	assert_eq(series.binned_data, expected)

func test_increment_bin_num_with_existing_bin():
	series.binned_data.clear()
	series._increment_bin_num(0)
	series._increment_bin_num(0)
	series._increment_bin_num(0)
	series._increment_bin_num(0)
	series._increment_bin_num(5)
	series._increment_bin_num(5)
	
	var expected = {
		0 : 4,
		5 : 2
	}
	assert_eq(series.binned_data, expected)

func test_bin_value_adds_positive_bins():
	series.x_min = 0
	series.bin_size = 10.0
	series.binned_data.clear()
	series._bin_value(8)
	series._bin_value(12)
	series._bin_value(19)
	var expected = {
		0 : 1,
		1 : 2
	}
	assert_eq(series.binned_data, expected)

func test_bin_value_adds_negative_bins():
	series.x_min = 50
	series.bin_size = 10.0
	series.binned_data.clear()
	series._bin_value(8)
	series._bin_value(12)
	series._bin_value(70)
	var expected = {
		-5: 1,
		-4 : 1,
		2 : 1
	}
	assert_eq(series.binned_data, expected)
