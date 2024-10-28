@tool
class_name PlotData extends Node

var type : QuantitativeSeries.TYPE
var points : PackedVector2Array = PackedVector2Array()
var color : Color
var size : float

func _init(series_type : QuantitativeSeries.TYPE, series_color : Color, series_size = 1.0) -> void:
	type = series_type
	color = series_color
	size = series_size

func add_point(point : Vector2) -> PlotData:
	points.append(point)
	return self

func set_points(point_array : PackedVector2Array) -> PlotData:
	points = point_array
	return self
