@tool
class_name QuantitativeSeries extends Node

enum TYPE {SCATTER, LINE, AREA}
signal property_changed

@export var type : TYPE = TYPE.SCATTER:
	set(value):
		type = value
		property_changed.emit()
@export var data : PackedVector2Array: 
	set(value):
		data = sort_by_x(value)
		property_changed.emit()
@export_group("Display")
@export var color : Color = Color.BLUE:
	set(value):
		color = value
		property_changed.emit()
@export var size : float = 10.0:
	set(value):
		size = value
		property_changed.emit()

func _init(series_type := TYPE.SCATTER, display_color := Color.BLUE, display_size := 10.0) -> void:
	type = series_type
	color = display_color
	size = display_size

func set_data(data_2D : PackedVector2Array):
	data = sort_by_x(data_2D)
	property_changed.emit()

func add_point(point : Vector2) -> void:
	data.append(point)
	data = sort_by_x(data)
	property_changed.emit()

func sort_by_x(series : PackedVector2Array) -> PackedVector2Array:
	var array := Array(series)
	array.sort_custom(point_sort)
	return PackedVector2Array(array)

func point_sort(a : Vector2, b : Vector2):
	if a.x == b.x:
		return a.y < b.y
	return a.x < b.x

func remove_point(point : Vector2):
	var point_idx = data.find(point)
	if point_idx <= -1 : return null
	var removed_point = data[point_idx]
	data.remove_at(point_idx)
	property_changed.emit()
	return removed_point
