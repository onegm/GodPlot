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
	series.set_data(data.duplicate())
	data.sort()
	assert_eq(series.data, data)

func test_add_point_adds_data():
	var point_to_add = 50
	series.add_point(point_to_add)
	assert_eq(series.data.size(), data.size() + 1)

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


func test_add_array_adds_data():
	var points_to_add : Array[float] = [50, 34.2, -80, 95]
	series.add_array(points_to_add)
	assert_eq(series.data.size(), data.size() + points_to_add.size())

func test_add_array_sorts_data():
	var points_to_add : Array[float] = [50, 34.2, -80, 95]
	series.add_array(points_to_add)
	data.append_array(points_to_add)
	data.sort()
	assert_eq(series.data, data)

func test_add_array_bins_data():
	var points_to_add : Array[float] = [50, 34.2, -80, 95]
	series.add_array(points_to_add)
	var expected = {
		-8 : 1,
		-6 : 1,
		0 : 2,
		1 : 1,
		2 : 2,
		3 : 3,
		5 : 1,
		6 : 1,
		8 : 1,
		9 : 2
	}
	assert_eq(series.get_binned_data(), expected)

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
	series._bin_data()
	
	assert_eq(series.binned_data, expected)

func test_get_binned_data_sorts_bins():
	series.binned_data = {
		8 : 5,
		2 : 3,
		0 : 1,
		4 : 1,
		3 : 1,
		7 : 1,
	}
	var expected = {
		0 : 1,
		2 : 3,
		3 : 1,
		4 : 1,
		7 : 1,
		8 : 5,
	}
	assert_eq(series.get_binned_data(), expected)
