@tool
class_name Series extends Node
## Abstract class for storing series info. Use inheriting classes. 

var min_values := Vector2(INF, INF)
var max_values := Vector2(-INF, -INF)
		
signal property_changed

func _init() -> void:
	push_error("Cannot instantiate abstract class: " + get_script().get_global_name())

func _update_min_and_max_values(point : Vector2):
	min_values = min_values.min(point)
	max_values = max_values.max(point)
