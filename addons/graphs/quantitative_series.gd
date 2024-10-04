@tool
class_name QuantitativeSeries extends Node

enum TYPE {SCATTER, LINE, AREA}
signal property_changed

@export var type : TYPE = TYPE.SCATTER:
	set(value):
		type = value
		property_changed.emit()
@export var data : PackedVector2Array : 
	set(value):
		data = value
		property_changed.emit()
@export_group("Display")
@export var color : Color = Color.BLUE:
	set(value):
		color = value
		property_changed.emit()
@export var size : float = 1.0:
	set(value):
		size = value
		property_changed.emit()

func add_point(point : Vector2) -> void:
	data.append(point)
	property_changed.emit()

func remove_point(point : Vector2):
	var point_idx = data.find(point)
	if point_idx <= -1 : return null
	var removed_point = data[point_idx]
	data.remove_at(point_idx)
	property_changed.emit()
	return removed_point
