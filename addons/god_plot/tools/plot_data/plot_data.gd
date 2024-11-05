@tool
class_name PlotData

var color : Color

static func new_scatter_point(position : Vector2, color := Color.BLUE, size := 5.0) -> ScatterPoint:
	return ScatterPoint.new(position, color, size)

static func new_line(line_color := Color.RED, thickness := 5.0) -> PlotData:
	return Line.new(line_color, thickness)

static func new_area(area_color : Color) -> PlotData:
	return Area.new(area_color)
