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
	
