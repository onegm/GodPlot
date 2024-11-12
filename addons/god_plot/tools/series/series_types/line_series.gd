class_name LineSeries extends Series

@export var thickness : float:
	set(value):
		thickness = value
		property_changed.emit()
		
func _init(line_color : Color, line_thickness : float) -> void:
	color = line_color
	thickness = line_thickness
