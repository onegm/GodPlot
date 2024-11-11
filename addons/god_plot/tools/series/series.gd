@tool
class_name Series extends Node

enum TYPE {
	SCATTER,
	LINE, 
	AREA 
	}
signal property_changed
var min_value := Vector2(INF, INF)
var max_value := Vector2(-INF, -INF)

@export var type : TYPE = TYPE.SCATTER:
	set(value):
		type = value
		property_changed.emit()
@export var data : PackedVector2Array: 
	set(value):
		data = _sort_by_x(value)
		property_changed.emit()
@export var color : Color = Color.BLUE:
	set(value):
		color = value
		property_changed.emit()
		
func _init() -> void:
	push_error("Cannot instantiate abstract class: " + get_script().get_global_name())

static func create_new(type : Series.TYPE, color := Color.BLUE, size := 10.0):
	match type:
		TYPE.SCATTER: return ScatterSeries.new(color, size)
		TYPE.LINE: return LineSeries.new(color, size)
		TYPE.AREA: return AreaSeries.new(color)
		_: push_error("Cannot create series of type: " + str(type))

func _set_data(data_2D : PackedVector2Array):
	data = _sort_by_x(data_2D)
	property_changed.emit()

func add_point(point : Vector2) -> void:
	data.append(point)
	data = _sort_by_x(data)
	_update_min_and_max(point)
	property_changed.emit()

func _update_min_and_max(point : Vector2):
	min_value = min_value.min(point)
	max_value = max_value.max(point)

static func _sort_by_x(series : PackedVector2Array) -> PackedVector2Array:
	var array := Array(series)
	array.sort_custom(_point_sort)
	return PackedVector2Array(array)

static func _point_sort(a : Vector2, b : Vector2):
	if a.x == b.x:
		return a.y < b.y
	return a.x < b.x

func remove_point(point : Vector2):
	var point_idx = data.find(point)
	if point_idx <= -1 : return null
	var removed_point = data[point_idx]
	data.remove_at(point_idx)
	property_changed.emit()
	_recalculate_min_and_max()
	return removed_point

func _recalculate_min_and_max():
	min_value = Vector2(INF, INF)
	max_value = Vector2(-INF, -INF)
	for point in data:
		min_value = min_value.min(point)
		max_value = max_value.max(point)
	
func remove_point_by_x(x : float):
	var point = Array(data).filter(func(point): return point.x == x).pop_front()
	return remove_point(point)

func clear_data():
	_set_data(PackedVector2Array())
