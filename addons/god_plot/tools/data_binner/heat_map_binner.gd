class_name HeatMapBinner

var heat_map : HeatMap
var binned_data : Dictionary = {}

func _init(heat_map_to_bin : HeatMap) -> void:
	heat_map = heat_map_to_bin
	heat_map.ready.connect(_initialize_binned_data_with_zeroes)

func _initialize_binned_data_with_zeroes():
	for x in range(heat_map.x_min, heat_map.x_max, heat_map.bin_size.x):
		for y in range(heat_map.y_min, heat_map.y_max, heat_map.bin_size.y):
			var bin_position = get_bin_position(Vector2(x, y))
			if binned_data.has(bin_position): continue
			binned_data[bin_position] = 0

func get_binned_data() -> Dictionary:
	return binned_data

func bin_all_data(data : PackedVector2Array) -> void:
	binned_data.clear()
	_initialize_binned_data_with_zeroes()
	Array(data).map(bin_point)

func bin_point(point : Vector2) -> Vector2:
	var bin_position = get_bin_position(point)
	increment_bin(bin_position)
	return bin_position

func get_bin_position(point : Vector2) -> Vector2:
	return Vector2(
		floor((point.x - heat_map.x_min) / heat_map.bin_size.x),
		floor((point.y - heat_map.y_min) / heat_map.bin_size.y)
	)

func increment_bin(bin_position : Vector2):
	if binned_data.has(bin_position):
		binned_data[bin_position] += 1
	else:
		binned_data[bin_position] = 1
