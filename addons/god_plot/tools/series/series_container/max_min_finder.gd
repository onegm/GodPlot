class_name MaxMinFinder

const grouped_types : Array[Array] = [
	[TYPE_INT, TYPE_FLOAT],
	[TYPE_VECTOR2, TYPE_VECTOR2I]
]

enum {SCALAR, VECTOR}

static func find_min(value_1, value_2):
	if not types_are_compatible(value_1, value_2):
		return
	return find_min_by_type(value_1, value_2)

static func find_min_by_type(value_1, value_2):
	if typeof(value_1) in grouped_types[SCALAR]:
		return min(value_1, value_2)
	elif typeof(value_1) in grouped_types[VECTOR]:
		return value_1.min(value_2)
	else: return null

static func find_max(value_1, value_2):
	if not types_are_compatible(value_1, value_2):
		return
	return find_max_by_type(value_1, value_2)

static func find_max_by_type(value_1, value_2):
	if typeof(value_1) in grouped_types[SCALAR]:
		return max(value_1, value_2)
	elif typeof(value_1) in grouped_types[VECTOR]:
		return value_1.max(value_2)
	else: return null

static func types_are_compatible(value_1, value_2):
	if not [value_1, value_2].all(is_acceptable_type):
		return false
		
	for group in grouped_types:
		if (typeof(value_1) in group) and (typeof(value_2) in group):
			return true
	printerr("Incompatible types: " + 
		type_string(typeof(value_1)) + " & " + 
		type_string(typeof(value_2))
		)

static func is_acceptable_type(value):
	for group in grouped_types:
		if typeof(value) in group: return true
		
	printerr("Unaccepted type: " + type_string(typeof(value)))
	return false
