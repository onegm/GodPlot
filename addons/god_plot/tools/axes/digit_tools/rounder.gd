class_name Rounder

static func floor_vector_to_decimal_places(vector : Vector2, decimal_places : Vector2) -> Vector2:
	return Vector2(
		floor_num_to_decimal_place(vector.x, decimal_places.x),
		floor_num_to_decimal_place(vector.y, decimal_places.y)
	)

static func floor_num_to_decimal_place(num : float, decimal_place : int) -> float:
	return floor(num * pow(10, decimal_place)) / pow(10, decimal_place)

static func ceil_vector_to_decimal_places(vector : Vector2, decimal_places : Vector2) -> Vector2:
	return Vector2(
		ceil_num_to_decimal_place(vector.x, decimal_places.x),
		ceil_num_to_decimal_place(vector.y, decimal_places.y)
	)

static func ceil_num_to_decimal_place(num : float, decimal_place : int) -> float:
	return ceil(num * pow(10, decimal_place)) / pow(10, decimal_place)

static func round_num_to_decimal_place(num : float, decimal_place : int) -> float:
	return round(num * pow(10, decimal_place)) / pow(10, decimal_place)
