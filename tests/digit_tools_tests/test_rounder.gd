extends GutTest

func test_round_num_to_decimal_place():
	assert_eq(Rounder.round_num_to_decimal_place(5.352, 0), 5.0)
	assert_eq(Rounder.round_num_to_decimal_place(5.352, 1), 5.4)
	assert_eq(Rounder.round_num_to_decimal_place(-5.352, 2), -5.35)

func test_floor_num_to_decimal_place():
	assert_eq(Rounder.floor_num_to_decimal_place(2.584, 0), 2.0)
	assert_eq(Rounder.floor_num_to_decimal_place(-2.584, 1), -2.6)
	assert_eq(Rounder.floor_num_to_decimal_place(2.584, 3), 2.584)
	assert_eq(Rounder.floor_num_to_decimal_place(2.584, 4), 2.584)
		
func test_floor_num_does_not_change_whole_number():
	assert_eq(Rounder.floor_num_to_decimal_place(2.000, 1), 2.0)
	assert_eq(Rounder.floor_num_to_decimal_place(-7.000, 3), -7.0)
	
func test_ceil_num_to_decimal_place():
	assert_eq(Rounder.ceil_num_to_decimal_place(2.584, 0), 3.0)
	assert_eq(Rounder.ceil_num_to_decimal_place(-2.584, 1), -2.5)
	assert_eq(Rounder.ceil_num_to_decimal_place(2.584, 3), 2.584)
	assert_eq(Rounder.ceil_num_to_decimal_place(2.584, 4), 2.584)
		
func test_ceil_num_does_not_change_whole_number():
	assert_eq(Rounder.ceil_num_to_decimal_place(2.000, 1), 2.0)
	assert_eq(Rounder.ceil_num_to_decimal_place(-7.000, 3), -7.0)
	
func test_floor_vector_to_decimal_places():
	var vector = Vector2(12.735, -804.32)
	var decimal_places = Vector2(0, 1)
	var expected = Vector2(12, -804.4)
	var result = Rounder.floor_vector_to_decimal_places(vector, decimal_places)
	assert_eq(result, expected)
	
func test_ceil_vector_to_decimal_places():
	var vector = Vector2(12.735, -804.32)
	var decimal_places = Vector2(0, 1)
	var expected = Vector2(13, -804.3)
	var result = Rounder.ceil_vector_to_decimal_places(vector, decimal_places)
	assert_eq(result, expected)

func test_ceil_num_to_multiple():
	var num = 53.2
	var multiple = 10.0
	var expected = 60.0
	assert_eq(Rounder.ceil_num_to_multiple(num, multiple), expected)

func test_ceil_num_to_multiple_with_negative():
	var num = -53.2
	var multiple = 10.0
	var expected = -50.0
	assert_eq(Rounder.ceil_num_to_multiple(num, multiple), expected)

func test_ceil_num_to_multiple_with_multiple_less_than_one():
	var num = 53.2
	var multiple = 0.5
	var expected = 53.5
	assert_eq(Rounder.ceil_num_to_multiple(num, multiple), expected)
