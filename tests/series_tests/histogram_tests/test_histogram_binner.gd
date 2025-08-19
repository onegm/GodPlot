extends GutTest

var binner : HistogramBinner
var data : Array[float]

func before_each():
	data = [
		7, 10, 2, 22.5, 83, 25, -52, 30, 31, 65, 99
	]
	var series = autofree(HistogramSeries.new())
	series.x_min = 0.0
	series.bin_size = 10.0
	series.set_data(data)
	
	binner = autofree(HistogramBinner.new(series))


func test_get_bin_num():
	assert_eq(binner.get_bin_num(0), 0)
	assert_eq(binner.get_bin_num(9), 0)
	assert_eq(binner.get_bin_num(10), 1)
	assert_eq(binner.get_bin_num(124), 12)

func test_get_bin_num_with_negative_bins():
	assert_eq(binner.get_bin_num(-5), -1)
	assert_eq(binner.get_bin_num(-12), -2)

func test_get_bin_num_with_different_x_min():
	binner.histogram_series.x_min = 25
	binner.histogram_series.bin_size = 25
	assert_eq(binner.get_bin_num(9), -1)
	assert_eq(binner.get_bin_num(25), 0)
	assert_eq(binner.get_bin_num(49), 0)
	assert_eq(binner.get_bin_num(50), 1)
	assert_eq(binner.get_bin_num(100), 3)


func test_increment_bin_num_with_new_bin():
	binner.histogram_series.binned_data.clear()
	binner.increment_bin_num(0)
	binner.increment_bin_num(5)
	
	var expected = {
		0 : 1,
		5 : 1
	}
	assert_eq(binner.binned_data, expected)

func test_increment_bin_num_with_existing_bin():
	binner.binned_data.clear()
	binner.increment_bin_num(0)
	binner.increment_bin_num(0)
	binner.increment_bin_num(0)
	binner.increment_bin_num(0)
	binner.increment_bin_num(5)
	binner.increment_bin_num(5)
	
	var expected = {
		0 : 4,
		5 : 2
	}
	assert_eq(binner.binned_data, expected)

func test_bin_value_adds_positive_bins():
	binner.histogram_series.x_min = 0
	binner.histogram_series.bin_size = 10.0
	binner.binned_data.clear()
	binner.bin_value(8)
	binner.bin_value(12)
	binner.bin_value(19)
	var expected = {
		0 : 1,
		1 : 2
	}
	assert_eq(binner.binned_data, expected)

func test_bin_value_adds_negative_bins():
	binner.histogram_series.x_min = 50
	binner.histogram_series.bin_size = 10.0
	binner.histogram_series.binned_data.clear()
	binner.bin_value(8)
	binner.bin_value(12)
	binner.bin_value(70)
	var expected = {
		-5: 1,
		-4 : 1,
		2 : 1
	}
	assert_eq(binner.binned_data, expected)
