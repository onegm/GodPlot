@tool
class_name AreaSeries extends Series2D

@export var color : Color = Color.BLUE:
	set(value):
		color = value
		property_changed.emit()

func _init(display_color : Color = Color.BLUE) -> void:
	color = display_color
