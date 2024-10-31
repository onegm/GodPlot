@tool
class_name PlotData extends Node

var type : Series.TYPE
var points : PackedVector2Array = PackedVector2Array()
var color : Color
var size : float

static func new_scatter_point(coordinates : Vector2, point_color : Color, point_size : float) -> PlotData:
	var plot_point = PlotData.new(Series.TYPE.SCATTER, point_color, point_size)
	plot_point.add_point(coordinates)
	return plot_point

static func new_line(line_color : Color, thickness : float) -> PlotData:
	return PlotData.new(Series.TYPE.LINE, line_color, thickness)

static func new_area(polygon : PackedVector2Array, area_color : Color) -> PlotData:
	var area = PlotData.new(Series.TYPE.AREA, area_color)
	area.points = polygon
	return area

func _init(the_type : Series.TYPE, the_color : Color, the_size = 1.0) -> void:
	type = the_type
	color = the_color
	size = the_size

func add_point(point : Vector2) -> PlotData:
	points.append(point)
	return self
