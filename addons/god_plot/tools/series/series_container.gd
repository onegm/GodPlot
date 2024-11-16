@tool
class_name SeriesContainer extends Node

var series_arr : Array[Series] = []

signal redraw_requested

func add_series(series : Series):
	if series_arr.has(series):
		return
	series_arr.append(series)
	series.property_changed.connect(redraw_requested.emit)
	redraw_requested.emit()
	
func remove_series(series : Series):
	series.property_changed.disconnect(redraw_requested.emit)
	series_arr.erase(series)

func get_all_series() -> Array[Series]:
	return series_arr

func get_min_value() -> Vector2:
	var min_value := Vector2(INF, INF)
	for series in series_arr:
		min_value = min_value.min(series.min_value)
	return min_value
	
func get_max_value() -> Vector2:
	var max_value := Vector2(-INF, -INF)
	for series in series_arr:
		max_value = max_value.max(series.max_value)
	return max_value

func clear():
	for series in series_arr.duplicate():
		remove_series(series)
