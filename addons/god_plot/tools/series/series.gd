@tool
class_name Series extends Node
## Abstract class for storing series info. Use inheriting classes. 

signal property_changed
var min_limits := Vector2(INF, INF)
var max_limits := Vector2(-INF, -INF)
@export var color : Color = Color.BLUE:
	set(value):
		color = value
		property_changed.emit()
		
func _init() -> void:
	push_error("Cannot instantiate abstract class: " + get_script().get_global_name())

func _update_min_and_max_limits(point : Vector2):
	min_limits = min_limits.min(point)
	max_limits = max_limits.max(point)

func get_color() -> Color:
	return color
