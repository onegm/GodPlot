extends GutTest

func test_get_max_num_digits():
	assert_eq(DigitCounter.get_max_num_digits(5, 7), 1)
	assert_eq(DigitCounter.get_max_num_digits(1, 10), 2)
	assert_eq(DigitCounter.get_max_num_digits(-152, 1), 3)
	assert_eq(DigitCounter.get_max_num_digits(152, 100), 3)

func test_get_num_digits():
	assert_eq(DigitCounter.get_num_digits(5), 1)
	assert_eq(DigitCounter.get_num_digits(10), 2)
	assert_eq(DigitCounter.get_num_digits(100), 3)
	assert_eq(DigitCounter.get_num_digits(-15), 2)
	assert_eq(DigitCounter.get_num_digits(256), 3)

func test_get_num_digits_zero_is_one():
	assert_eq(DigitCounter.get_num_digits(0), 1)

func test_get_num_digits_ignores_decimals():
	assert_eq(DigitCounter.get_num_digits(5.325), 1)
	assert_eq(DigitCounter.get_num_digits(-15.257), 2)
	assert_eq(DigitCounter.get_num_digits(000.0000), 1)
