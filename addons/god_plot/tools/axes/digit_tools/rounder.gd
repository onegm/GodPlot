class_name Rounder

static func round_num_to_decimal_place(num : float, decimal_place : int) -> float:
	return round(num * pow(10, decimal_place)) / pow(10, decimal_place)

static func floor_num_to_decimal_place(num : float, decimal_place : int) -> float:
	return floor(num * pow(10, decimal_place)) / pow(10, decimal_place)

static func ceil_num_to_decimal_place(num : float, decimal_place : int) -> float:
	return ceil(num * pow(10, decimal_place)) / pow(10, decimal_place)
