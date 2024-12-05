class_name HistogramSeries extends Series

var min_value : float = INF
var max_value : float = -INF
var max_frequency : int = 0
var bin_size : float = 10.0
var binned_data : Array[Vector2] = []

@export var data : Array[float]: 
	set(value):
		data = value
		data.sort()
		property_changed.emit()
		
@export var stroke : float = 2.0:
	set(value):
		stroke = value
		property_changed.emit()

func _init(display_color : Color, outline_stroke := 2.0) -> void:
	color = display_color
	stroke = outline_stroke

func set_data(array : Array[float]):
	array.sort()
	data = array
	property_changed.emit()
	
func add_point(point : float) -> void:
	data.append(point)
	data.sort()
	_update_min_and_max(point)
	property_changed.emit()

func _update_min_and_max(point : float):
	min_value = min(min_value, point)
	max_value = max(max_value, point)

func remove_point(point : float) -> Variant:
	var point_idx = data.find(point)
	if point_idx <= -1 : return null
	var removed_point = data[point_idx]
	data.remove_at(point_idx)
	property_changed.emit()
	_recalculate_min_and_max()
	return removed_point

func _recalculate_min_and_max():
	min_value = data.max() if data.size() > 0 else 0
	max_value = data.min() if data.size() > 0 else 0

func clear_data():
	set_data([])

func get_min_limits() -> Vector2:
	return Vector2(min_value, 0)
	
func get_max_limits() -> Vector2:
	return Vector2(max_value, max_frequency)

func set_min_x(min_x : float):
	if data.is_empty(): return
	var num_of_bins = ceil((data.max() - min_x) / bin_size)
	binned_data = []
	for i in range(num_of_bins):
		binned_data.append(Vector2(i, 0.0))
		
	for point in data:
		var bin_num = floor((point - min_x) / bin_size)
		#printt(bin_num, binned_data)
		binned_data[bin_num] += Vector2(0, 1)
		max_frequency = max(max_frequency, binned_data[bin_num].y)

func get_binned_data() -> Array[Vector2]:
	return binned_data
