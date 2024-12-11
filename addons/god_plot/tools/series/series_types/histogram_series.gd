@tool
class_name HistogramSeries extends Series

@export var data : Array[float] = []

var min_x : float = 0.0
var bin_size : float = 10.0
var binned_data : Dictionary = {}

func _init() -> void:
	pass

func add_point(x : float) -> void:
	data.append(x)
	data.sort()
	bin_data()
	property_changed.emit()

func bin_data():
	binned_data.clear()
	var min = min_x
	var max = min_x + bin_size
	var bin_num : int = 0
	var i = 0
	while i < data.size():
		var value = data[i]
		if value >= min and value < max:
			increment_bin_num(bin_num)
			i += 1
		elif value >= max:
			bin_num += 1
			min += bin_size
			max += bin_size

func increment_bin_num(bin_num : int):
	if binned_data.has(bin_num):
		binned_data[bin_num] += 1
	else:
		binned_data[bin_num] = 1

func _recalculate_min_and_max_limits():
	var max_count = get_max_count_in_binned_data()
	var max_x = min_x + binned_data.keys().back() * bin_size
	
	min_limits = Vector2(min_x, 0)
	max_limits = Vector2(max_x, max_count)

func get_max_count_in_binned_data():
	var max_count = 0
	for count in binned_data.values():
		if count > max_count:
			max_count = count
	return max_count

func remove_point(x : float):
	data.erase(x)
	bin_data()
	property_changed.emit()
