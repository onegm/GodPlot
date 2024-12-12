@tool
class_name HistogramSeries extends Series

@export var data : Array[float] = []

var min_x : float = 0.0:
	set(value):
		min_x = value
		_bin_data()
var bin_size : float = 10.0
var binned_data : Dictionary = {}

func _init() -> void:
	pass

func add_point(value : float) -> void:
	data.append(value)
	data.sort()
	_bin_value(value)
	property_changed.emit()

func _bin_data() -> Dictionary:
	binned_data.clear()
	data.map(_bin_value)
	property_changed.emit()
	return binned_data

func _bin_value(value : float) -> void:
	var bin_num = get_bin_num(value)
	_increment_bin_num(bin_num)

func get_bin_num(value : float) -> int:
	return floor((value - min_x) / bin_size)

func _increment_bin_num(bin_num : int):
	if binned_data.has(bin_num):
		binned_data[bin_num] += 1
	else:
		binned_data[bin_num] = 1

func _recalculate_min_and_max_limits():
	var max_count = binned_data.values().max()
	var x_min = min_x + binned_data.keys().min() * bin_size
	var x_max = min_x + binned_data.keys().max() * bin_size
	
	min_limits = Vector2(x_min, 0)
	max_limits = Vector2(x_max, max_count)

func remove_point(x : float):
	data.erase(x)
	property_changed.emit()

func clear_data():
	set_data([])
	binned_data.clear()

func set_data(new_data : Array[float]):
	data = new_data.duplicate()
	data.sort()
	_bin_data()
	property_changed.emit()
