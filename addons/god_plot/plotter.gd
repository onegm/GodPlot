@tool
class_name Plotter extends Control

var to_draw : Array = []

func _draw() -> void:
	for point in to_draw:
		match point[0]:
			QuantitativeSeries.TYPE.SCATTER:
				draw_circle(point[1], point[2], point[3])
			QuantitativeSeries.TYPE.LINE:
				draw_polyline(point[1], point[2], point[3])
			QuantitativeSeries.TYPE.AREA:
				draw_colored_polygon(point[1], point[2])
