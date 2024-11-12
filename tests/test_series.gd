extends GutTest

var series : Series

var unsorted_packed_vector2_array := PackedVector2Array([
	Vector2(-2, 7),
	Vector2(-1, 5),
	Vector2(3, -2),
	Vector2(1, 4),
	Vector2(-2, 5),
	])

var sorted_packed_vector2_array := PackedVector2Array([
	Vector2(-2, 5),
	Vector2(-2, 7),
	Vector2(-1, 5),
	Vector2(1, 4),
	Vector2(3, -2),
])

func before_each():
	series = autofree(ScatterSeries.new())
	series.set_data(sorted_packed_vector2_array)

func test_static_sort_by_x():
	var result = Series._sort_by_x(unsorted_packed_vector2_array)
	assert_eq(result, sorted_packed_vector2_array)

func test_clear():
	series.clear_data()
	assert_eq(series.data, PackedVector2Array())

func test_set_data():
	series.clear_data()
	assert_eq(series.data, PackedVector2Array())
	series.set_data(unsorted_packed_vector2_array)
	assert_eq(series.data, sorted_packed_vector2_array)

func test_add_point_to_end():
	var point_to_add = Vector2(100, 0)
	series.add_point_vector(point_to_add)
	
	var expected = sorted_packed_vector2_array + PackedVector2Array([point_to_add])
	
	assert_eq(series.data, expected)
	
func test_add_point_to_front():
	var point_to_add = Vector2(-100, 0)
	series.add_point_vector(point_to_add)
	
	var expected = PackedVector2Array([point_to_add]) + sorted_packed_vector2_array
	
	assert_eq(series.data, expected)

func test_add_point_in_middle():
	var point_to_add = Vector2(0, 0)
	series.add_point_vector(point_to_add)
	
	var expected = Series._sort_by_x(PackedVector2Array([point_to_add]) + sorted_packed_vector2_array)
	
	assert_eq(series.data, expected)

func test_remove_point_that_exists():
	var index = randi() % series.data.size()
	var point_to_remove = sorted_packed_vector2_array[index]
	series.remove_point(point_to_remove)
	
	var expected = sorted_packed_vector2_array.duplicate()
	expected.remove_at(index)
	
	assert_eq(series.data, expected)

func test_remove_point_that_does_not_exist():
	var point_to_remove = Vector2(-99, -99)
	assert_does_not_have(series.data, point_to_remove)
	series.remove_point(point_to_remove)
	
	assert_eq(series.data, sorted_packed_vector2_array)
