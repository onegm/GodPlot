class_name DigitCounter

static func get_max_num_digits(num_1 : float, num_2 : float) -> int:
	return max(get_num_digits(num_1), get_num_digits(num_2))

static func get_num_digits(num : float) -> int:
	num = abs(num)
	if is_equal_approx(num, 0):
		return 1
	return floor(log(num)/log(10)) + 1
