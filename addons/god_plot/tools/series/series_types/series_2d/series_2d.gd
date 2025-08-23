@tool
class_name Series2D extends Series

@export var data : PackedVector2Array: 
	set(value):
		data = _sort_by_x(value)
		property_changed.emit()

func _init() -> void:
	pass

static func from_point_array(point_array : Array[Vector2]) -> Series2D:
	var new_series_2d : Series2D = Series2D.new()
	new_series_2d.data = PackedVector2Array(point_array)
	return new_series_2d

func add_point(x : float, y : float) -> void:
	add_point_vector(Vector2(x, y))
	
func add_point_vector(point : Vector2) -> void:
	data.append(point)
	data = _sort_by_x(data)
	_update_min_and_max_values(point)
	property_changed.emit()

func add_point_array(points : Array[Vector2]) -> void:
	data.append_array(PackedVector2Array(points))
	data = _sort_by_x(data)
	_recalculate_min_and_max_limits()
	property_changed.emit()

func remove_point(point : Vector2):
	var point_idx = data.find(point)
	if point_idx <= -1 : return null
	var removed_point = data[point_idx]
	data.remove_at(point_idx)
	property_changed.emit()
	_recalculate_min_and_max_limits()
	return removed_point

func clear_data():
	set_data(PackedVector2Array())

func set_data_from_Vector2_array(array : Array[Vector2]):
	set_data(PackedVector2Array(array))
	
func set_data(data_2D : PackedVector2Array):
	data = _sort_by_x(data_2D)
	_recalculate_min_and_max_limits()
	property_changed.emit()
	
static func _sort_by_x(series : PackedVector2Array) -> PackedVector2Array:
	var array := Array(series)
	array.sort_custom(_point_sort)
	return PackedVector2Array(array)

static func _point_sort(a : Vector2, b : Vector2):
	if a.x == b.x:
		return a.y < b.y
	return a.x < b.x

func _recalculate_min_and_max_limits():
	min_values = Vector2(INF, INF)
	max_values = Vector2(-INF, -INF)
	Array(data).map(_update_min_and_max_values)
