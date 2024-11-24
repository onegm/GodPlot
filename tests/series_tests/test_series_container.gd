extends GutTest

var series_container : SeriesContainer
var series_1 : ScatterSeries
var series_2 : ScatterSeries
var series_3 : ScatterSeries

func before_all():
	series_container = SeriesContainer.new()
	series_1 = ScatterSeries.new()
	series_2 = ScatterSeries.new()
	series_3 = ScatterSeries.new()

func before_each():
	series_container.clear()

func test_signals_start_disconnected():
	assert_false(series_container.is_series_connected(series_1))
	assert_false(series_container.is_series_connected(series_2))
	assert_false(series_container.is_series_connected(series_3))

func test_add_series_connects_signal():
	series_container.add_series(series_1)
	assert_true(series_container.is_series_connected(series_1))
	
func test_remove_series_disconnects_signal():
	series_container.add_series(series_1)
	series_container.add_series(series_2)
	series_container.add_series(series_3)
	
	series_container.remove_series(series_2)
	assert_false(series_container.is_series_connected(series_2))
	assert_true(series_container.is_series_connected(series_1))
	assert_true(series_container.is_series_connected(series_3))
	
func test_clear():
	series_container.add_series(series_1)
	series_container.add_series(series_2)
	series_container.add_series(series_3)
	
	series_container.clear()
	assert_eq(series_container.get_all_series().size(), 0)

func test_add_series_in_order():
	series_container.add_series(series_1)
	assert_eq(series_container.get_all_series(), [series_1])
	series_container.add_series(series_2)
	assert_eq(series_container.get_all_series(), [series_1, series_2])
	series_container.add_series(series_3)
	assert_eq(series_container.get_all_series(), [series_1, series_2, series_3])

func test_add_series_does_not_add_duplicates():
	series_container.add_series(series_1)
	series_container.add_series(series_1)
	assert_eq(series_container.get_all_series(), [series_1])
	
func test_remove_series():
	series_container.add_series(series_1)
	series_container.add_series(series_2)
	series_container.add_series(series_3)
	
	series_container.remove_series(series_2)
	
	assert_eq(series_container.get_all_series(), [series_1, series_3])
	
func test_get_min_value():
	series_1.add_point(5, 10)
	series_2.add_point(6, 8)
	series_container.add_series(series_1)
	series_container.add_series(series_2)
	assert_eq(series_container.min_value, Vector2(5, 8))
	series_1.add_point(-4, -2)
	assert_eq(series_container.min_value, Vector2(-4, -2))
	
func test_get_max_value():
	series_1.add_point(5, 10)
	series_2.add_point(6, 8)
	series_container.add_series(series_1)
	series_container.add_series(series_2)
	assert_eq(series_container.max_value, Vector2(6, 10))
	series_1.add_point(14, 22)
	assert_eq(series_container.max_value, Vector2(14, 22))

func after_all():
	series_1.queue_free()
	series_2.queue_free()
	series_3.queue_free()
	series_container.queue_free()
