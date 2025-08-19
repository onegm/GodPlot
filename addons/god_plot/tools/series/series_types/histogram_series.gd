@tool
class_name HistogramSeries extends Series

@export var color : Color = Color.BLUE:
	set(value):
		color = value
		property_changed.emit()

@export var data : Array[float] = []

var x_min : float = 0.0
var x_max : float = 10.0

var bin_size : float = 10.0
var binned_data : Dictionary = {}
var histogram_binner : HistogramBinner = HistogramBinner.new(self)

func _init(display_color : Color = Color.BLUE) -> void:
	color = display_color

func add_point(value : float) -> void:
	data.append(value)
	data.sort()
	var bin_num = histogram_binner.bin_value(value)
	_update_min_and_max_limits(Vector2(value, binned_data[bin_num]))
	property_changed.emit()

func add_array(values : Array[float]) -> void:
	data.append_array(values)
	data.sort()
	values.map(histogram_binner.bin_value)
	_recalculate_min_and_max_limits()
	property_changed.emit()

func _bin_data():
	binned_data = histogram_binner.get_binned_data()

func _recalculate_min_and_max_limits():
	var max_count = binned_data.values().max() if !binned_data.is_empty() else 0.0
	var min_bin = binned_data.keys().min() if !binned_data.is_empty() else 0.0
	var max_bin = binned_data.keys().max() if !binned_data.is_empty() else 0.0
	
	var min_x = x_min + min_bin * bin_size
	var max_x = x_min + max_bin * bin_size
	
	min_limits = Vector2(min_x, 0)
	max_limits = Vector2(max_x, max_count)

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
	histogram_binner.outlier_behavior = behavior

func get_bars_center_positions() -> Array[Vector2]:
	var result : Array[Vector2] = []
	for bin in binned_data.keys():
		result.append(
			Vector2(
				_bin_num_to_center_value(bin),
				binned_data[bin]
			)
		)
	return result
	
func _bin_num_to_center_value(bin_num : int) -> float:
	return x_min + bin_num * bin_size + bin_size / 2.0

func get_binned_data() -> Dictionary:
	var keys = binned_data.keys()
	keys.sort()
	var result_dict = {}
	keys.map(func(key): result_dict[key] = binned_data[key])
	return result_dict

func get_data() -> Array[float]:
	return data
