class_name QuantitativeSeries extends Node

@export var data : PackedVector2Array
@export_group("Display")
@export var color : Color = Color.BLUE
@export var size : float = 1.0

func add_point(point : Vector2) -> void:
	data.append(point)

func remove_point(point : Vector2):
	var point_idx = data.find(point)
	if point_idx <= -1 : return null
	var removed_point = data[point_idx]
	data.remove_at(point_idx)
	return removed_point
