@tool
class_name HeatMap extends Graph2D
## A node for creating heat maps.

@export var gradient : Gradient = Gradient.new()
@export var min_value : float = 0.0
@export var max_value : float = 10.0
@export var bin_width : float = 10.0:
	set(value):
		bin_width = abs(value)
		update_bin_size()
@export var bin_height : float = 10.0:
	set(value):
		bin_height = abs(value)
		update_bin_size()

var heat_map_binner : HeatMapBinner = HeatMapBinner.new(self)
var bin_size : Vector2 = Vector2(10, 10)

func _validate_property(property: Dictionary) -> void:
	if property.name in [
		"auto_scaling",
		"x_tick_count",
		"y_tick_count"
		]:
		property.usage = PROPERTY_USAGE_NO_EDITOR

func _ready() -> void:
	plotter = HeatMapPlotter.new(self)
	super._ready()
	auto_scaling = false
	_load_children_series()

func _load_children_series():
	if !is_inside_tree(): return
	
	series_container.remove_all_series()
	var all_series : Array = get_children().filter(func(child): return child is Series2D)
	if all_series.is_empty(): return
	add_series(all_series.front())
	if all_series.size() > 1:
		push_warning("HeatMap has more than one Series child. Only first series is used.")

func add_series(series : Series):
	if series is not HeatMapSeries:
		printerr(series, " is not a HeatMapSeries")
		return
	change_series(series as HeatMapSeries)

func change_series(heat_map_series: HeatMapSeries):
	series_container.remove_all_series()
	super.add_series(heat_map_series)
	heat_map_series.heat_map_binner = heat_map_binner
	heat_map_series.bin_data()

func set_x_max(value : float):
	x_max = _get_valid_x_max_from_value(value)
	super.set_x_max(x_max)
	_update_tick_counts()

func set_x_min(value : float):
	x_min = _get_valid_x_min_from_value(value)
	super.set_x_min(x_min)
	_update_tick_counts()

func set_y_max(value : float):
	y_max = _get_valid_y_max_from_value(value)
	super.set_y_max(y_max)
	_update_tick_counts()

func set_y_min(value : float):
	y_min = _get_valid_y_min_from_value(value)
	super.set_y_min(y_min)
	_update_tick_counts()

func _get_valid_x_max_from_value(value : float) -> float:
	return Rounder.ceil_num_to_multiple(value - x_min, bin_size.x) + x_min

func _get_valid_y_max_from_value(value : float) -> float:
	return Rounder.ceil_num_to_multiple(value - y_min, bin_size.y) + y_min

func _get_valid_x_min_from_value(value : float) -> float:
	return Rounder.floor_num_to_multiple(value - x_min, bin_size.x) + x_min

func _get_valid_y_min_from_value(value : float) -> float:
	return Rounder.floor_num_to_multiple(value - y_min, bin_size.y) + y_min

func _update_tick_counts():
	x_tick_count = get_x_tick_count()
	y_tick_count = get_y_tick_count()

func get_x_tick_count() -> int:
	return int((x_max - x_min) / bin_width)

func get_y_tick_count() -> int:
	return int((y_max - y_min) / bin_height)

func update_bin_size():
	bin_size.x = get_effective_bin_width()
	bin_size.y = get_effective_bin_height()
	
	update_max_values()
	
	series_container.get_all_series().map(func(series): series.bin_data())
	queue_redraw()

func update_max_values():
	x_max = _get_valid_x_max_from_value(x_max)
	y_max = _get_valid_y_max_from_value(y_max)

func get_color_from_value(value : float):
	var mapped_value = remap(value, min_value, max_value, 0.0, 1.0)
	return gradient.sample(mapped_value)

func get_effective_bin_width():
	return bin_width / (x_gridlines_minor + 1)
	
func get_effective_bin_height():
	return bin_height / (y_gridlines_minor + 1)

func set_x_gridlines_minor(value : int):
	super.set_x_gridlines_minor(value)
	bin_size.x = get_effective_bin_width()

func set_y_gridlines_minor(value : int):
	super.set_y_gridlines_minor(value)
	bin_size.y = get_effective_bin_height()
	
