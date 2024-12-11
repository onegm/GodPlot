extends GutTest

var series : HistogramSeries
var data : Array[float]

func before_each():
	data = [
		7, 10, 2, 22.5, 83, 25, -52, 30, 31, 65, 99
	]
	series = autofree(HistogramSeries.new())
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

func test_remove_point_that_exists():
	var index = randi() % series.data.size()
	var point_to_remove = data[index]
	series.remove_point(point_to_remove)
	
	var expected = data.duplicate()
	expected.remove_at(index)
	
	assert_eq(series.data, expected)

func test_remove_point_that_does_not_exist():
	var point_to_remove = 1234
	assert_does_not_have(series.data, point_to_remove)
	series.remove_point(point_to_remove)
	assert_eq(series.data, data)
