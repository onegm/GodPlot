@tool
class_name ScatterSeries extends Series2D
## [Series] object to store scatter plot information. 

@export var size : float = 5.0:
	set(value):
		size = value
		property_changed.emit()
		
enum SHAPE {CIRCLE, SQUARE, TRIANGLE, X, STAR}
@export var shape : SHAPE = SHAPE.CIRCLE:
	set(value):
		shape = value
		property_changed.emit()

@export var color : Color = Color.BLUE:
	set(value):
		color = value
		property_changed.emit()
		
@export var filled : bool = true:
	set(value):
		filled = value
		property_changed.emit()
		
@export var stroke : float = 2.0:
	set(value):
		stroke = value
		property_changed.emit()

func _init(
		point_color := Color.BLUE, 
		point_size := 5.0, 
		point_shape := SHAPE.CIRCLE,
		fill_shape := true,
		outline_stroke := 2.0
		) -> void:
	color = point_color
	size = point_size
	shape = point_shape
	filled = fill_shape
	stroke = outline_stroke

func get_color() -> Color : return color
func get_size() -> float: return size
func get_shape() -> SHAPE: return shape
func is_filled() -> bool: return filled
func get_stroke() -> float: return stroke
