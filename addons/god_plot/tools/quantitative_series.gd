@tool
class_name QuantitativeSeries extends Node

## A class for storing and managing series data and display information. This class
## is designed to be used as child of [Plot2D] and does not have any graphical capabilities
## of its own.

enum TYPE { ## Determines how the [Plot2D] will display this series on the graph.
	SCATTER, ## Scatter plot with [member size] determining radius of each point.
	## Line graph with [member size] determining thickness of line. Must 
	## include at least [b]two[/b] data points to trigger drawing.
	LINE, 
	## Area graph. [member size] is not used in this case. Must 
	## include at least [b]two[/b] data points to trigger drawing.
	AREA 
	}
## Emitted when any property of the series is changed. Triggers a redraw of the graph.
signal property_changed

## Determines how the [Plot2D] will display this series on the graph.
@export var type : TYPE = TYPE.SCATTER:
	set(value):
		type = value
		property_changed.emit()
## The (x, y) values of the series. Must include at least [b]two[/b] data points to trigger
## drawing a [constant LINE] or [constant AREA] graph. 
@export var data : PackedVector2Array: 
	set(value):
		data = _sort_by_x(value)
		property_changed.emit()
@export_group("Display")
## Color of the series. Use transparency to allow for visible overlapping shapes. 
@export var color : Color = Color.BLUE:
	set(value):
		color = value
		property_changed.emit()
## Determines the display size of [constant SCATTER] (radius) and [constant LINE] (thickness) plots.
@export var size : float = 10.0:
	set(value):
		size = value
		property_changed.emit()

func _init(series_type := TYPE.SCATTER, display_color := Color.BLUE, display_size := 10.0) -> void:
	type = series_type
	color = display_color
	size = display_size

func _set_data(data_2D : PackedVector2Array):
	data = _sort_by_x(data_2D)
	property_changed.emit()

## Adds a point to [member data] and emits [signal property_changed] signal.
func add_point(point : Vector2) -> void:
	data.append(point)
	data = _sort_by_x(data)
	property_changed.emit()

func _sort_by_x(series : PackedVector2Array) -> PackedVector2Array:
	var array := Array(series)
	array.sort_custom(_point_sort)
	return PackedVector2Array(array)

func _point_sort(a : Vector2, b : Vector2):
	if a.x == b.x:
		return a.y < b.y
	return a.x < b.x

## Removes a data point and, if found, returns it (as a [Vector2]) and 
## emits [signal property_changed] signal. Returns null and does not emit a 
## signal if not found.
func remove_point(point : Vector2):
	var point_idx = data.find(point)
	if point_idx <= -1 : return null
	var removed_point = data[point_idx]
	data.remove_at(point_idx)
	property_changed.emit()
	return removed_point
## Removes a point from [member data] using only the x value. Then returns it (as a [Vector2]) and 
## emits [signal property_changed] signal if found. Returns null and does not emit a 
## signal if not found.
func remove_point_by_x(x : float):
	var point = Array(data).filter(func(point): return point.x == x).pop_front()
	return remove_point(point)

## Clears [member data] and emits [signal property_changed] signal. 
func clear():
	_set_data(PackedVector2Array())
