class_name Rounder

static func round_num_to_decimal_place(num : float, decimal_place : int) -> float:
	return round(num * pow(10, decimal_place)) / pow(10, decimal_place)

static func floor_vector_to_decimal_places(vector : Vector2, decimal_place : Vector2i) -> Vector2:
	var scale_factor = Vector2(pow(10, decimal_place.x), pow(10, decimal_place.y))
	return floor(vector * scale_factor) / scale_factor

static func ceil_vector_to_decimal_places(vector : Vector2, decimal_place : Vector2i) -> Vector2:
	var scale_factor = Vector2(pow(10, decimal_place.x), pow(10, decimal_place.y))
	return ceil(vector * scale_factor) / scale_factor
