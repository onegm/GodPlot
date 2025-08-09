@tool
class_name LineSeries extends Series2D


@export var color : Color = Color.BLUE:
	set(value):
		color = value
		property_changed.emit()

@export var thickness : float:
	set(value):
		thickness = value
		property_changed.emit()
		
func _init(line_color : Color = Color.BLUE, line_thickness : float = 2.0) -> void:
	color = line_color
	thickness = line_thickness
