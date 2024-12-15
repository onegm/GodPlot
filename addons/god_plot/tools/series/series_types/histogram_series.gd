@tool
class_name HistogramSeries extends Series

@export var data : Array[float] = []

var x_min : float = 0.0
var x_max : float = 10.0

var bin_size : float = 10.0
var binned_data : Dictionary = {}
var outlier_behavior : Histogram.OUTLIER = Histogram.OUTLIER.IGNORE

func _init(display_color : Color = Color.BLUE) -> void:
	color = display_color

func add_point(value : float) -> void:
	data.append(value)
	data.sort()
	var bin_num = _bin_value(value)
	_update_min_and_max_limits(Vector2(value, binned_data[bin_num]))
	property_changed.emit()

func add_array(values : Array[float]) -> void:
	data.append_array(values)
	data.sort()
	_bin_data()
	_recalculate_min_and_max_limits()
	property_changed.emit()

func _bin_data() -> Dictionary:
	binned_data.clear()
	data.map(_bin_value)
	return binned_data

func _bin_value(value : float) -> int:
	value = _value_adjusted_for_outlier_behavior(value)
	var bin_num = get_bin_num(value)
	_increment_bin_num(bin_num)
	return bin_num

func _value_adjusted_for_outlier_behavior(value : float) -> float:
	match outlier_behavior:
		Histogram.OUTLIER.IGNORE:
			return value
		Histogram.OUTLIER.INCLUDE:
			return clamp(value, x_min, x_max - bin_size / 2.0)
		Histogram.OUTLIER.FIT:
			return value
		_:
			return value

func get_bin_num(value : float) -> int:
	return floor((value - x_min) / bin_size)

func _increment_bin_num(bin_num : int):
	if binned_data.has(bin_num):
		binned_data[bin_num] += 1
	else:
		binned_data[bin_num] = 1

func _recalculate_min_and_max_limits():
	var max_count = binned_data.values().max()
	var x_min = x_min + binned_data.keys().min() * bin_size
	var x_max = x_min + binned_data.keys().max() * bin_size
	
	min_limits = Vector2(x_min, 0)
	max_limits = Vector2(x_max, max_count)

func remove_point(x : float):
	data.erase(x)
	_recalculate_min_and_max_limits()
	property_changed.emit()

func clear_data():
	set_data([])
	
func set_data(new_data : Array[float]):
	data = new_data.duplicate()
	data.sort()
	_bin_data()
	_recalculate_min_and_max_limits()
	property_changed.emit()

func set_properties_from_histogram(histogram : Histogram):
	_set_limits(histogram.x_min, histogram.x_max)
	_set_bin_size(histogram.bin_size)
	_set_outlier_behavior(histogram.outlier_behavior)
	
func _set_limits(min_x : float, max_x : float):
	x_min = min_x
	x_max = max_x
	_bin_data()

func _set_bin_size(size : float):
	bin_size = size
	_bin_data()

func _set_outlier_behavior(behavior : Histogram.OUTLIER):
	outlier_behavior = behavior

func get_bin_center_positions() -> Dictionary:
	var center_positions = {}
	for bin in binned_data.keys():
		center_positions[bin] = _bin_num_to_center_value(bin)
	return center_positions

func _bin_num_to_center_value(bin_num : int) -> float:
	return x_min + bin_num * bin_size + bin_size / 2.0

func get_bin_count(bin_num : int) -> int:
	if not binned_data.has(bin_num):
		return -1
	return binned_data[bin_num]
