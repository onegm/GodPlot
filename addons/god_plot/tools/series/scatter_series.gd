class_name ScatterSeries extends Series

@export var size : float:
	set(value):
		size = value
		property_changed.emit()

func _init(point_color := Color.BLUE, point_size := 5.0) -> void:
	color = point_color
	size = point_size
	type = TYPE.SCATTER
	
