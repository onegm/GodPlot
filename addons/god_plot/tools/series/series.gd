class_name Series extends Node

signal property_changed

@export var color : Color = Color.BLUE:
	set(value):
		color = value
		property_changed.emit()

func _init() -> void:
	push_error("Cannot instantiate abstract class: " + get_script().get_global_name())

func get_color() -> Color:
	return color
