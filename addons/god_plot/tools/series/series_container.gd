@tool
class_name SeriesContainer extends Node

var series_arr : Array[Series] = []
var min_value := Vector2(INF, INF)
var max_value := Vector2(-INF, -INF)

signal redraw_requested

func add_series(series : Series):
	if series_arr.has(series):
		return
	series_arr.append(series)
	series.property_changed.connect(on_property_changed)
	on_property_changed()

func on_property_changed():
	update_min_value()
	update_max_value()
	redraw_requested.emit()
	
func remove_series(series : Series):
	series.property_changed.disconnect(on_property_changed)
	series_arr.erase(series)

func get_all_series() -> Array[Series]:
	return series_arr

func update_min_value():
	min_value = Vector2(INF, INF)
	for series in series_arr:
		min_value = min_value.min(series.min_limits)
	
func update_max_value():
	max_value = Vector2(-INF, -INF)
	for series in series_arr:
		max_value = max_value.max(series.max_limits)

func clear():
	for series in series_arr.duplicate():
		remove_series(series)

func clear_data():
	for series in series_arr:
		series.clear_data()

func is_series_connected(series : Series):
	return series.property_changed.is_connected(on_property_changed)

func is_empty():
	return series_arr.is_empty()
