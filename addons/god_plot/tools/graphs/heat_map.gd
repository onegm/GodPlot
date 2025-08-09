@tool
class_name HeatMap extends Graph2D
## A node for creating heat maps.

@export var gradient : Gradient = Gradient.new()
@export var bin_width : float = 10.0:
	set(value):
		bin_width = abs(value)
		x_max = _get_valid_x_max_from_value(x_max)
		queue_redraw()
@export var bin_height : float = 10.0:
	set(value):
		bin_height = abs(value)
		y_max = _get_valid_y_max_from_value(y_max)
		queue_redraw()

func _validate_property(property: Dictionary) -> void:
	if property.name in [
		"x_tick_count",
		"x_gridlines_opacity",
		"x_gridlines_minor",
		"x_gridlines_minor_thickness",
		"y_gridlines_opacity",
		"y_gridlines_minor",
		"y_gridlines_minor_thickness",
		"y_tick_count"
		]:
		property.usage = PROPERTY_USAGE_NO_EDITOR

func _ready() -> void:
	plotter = Plotter.new()
	_setup_plotter()
	_load_children_series() ## overrite to limit to one child/series with warning

func set_x_max(value : float):
	x_max = _get_valid_x_max_from_value(value)
	super.set_x_max(x_max)

func set_x_min(value : float):
	x_min = _get_valid_x_min_from_value(value)
	super.set_x_min(x_min)

func set_y_max(value : float):
	y_max = _get_valid_y_max_from_value(value)
	super.set_y_max(y_max)

func set_y_min(value : float):
	y_min = _get_valid_y_min_from_value(value)
	super.set_y_min(y_min)

func _get_valid_x_max_from_data() -> float:
	var data_max_x = series_container.max_value.x
	if _is_on_bin_edge(data_max_x):
		data_max_x += bin_width / 2.0
	data_max_x = _get_valid_x_max_from_value(data_max_x)
	return data_max_x

func _get_valid_x_max_from_value(value : float) -> float:
	return Rounder.ceil_num_to_multiple(value - x_min, bin_width) + x_min

func _get_valid_y_max_from_value(value : float) -> float:
	return Rounder.ceil_num_to_multiple(value - y_min, bin_height) + y_min

func _get_valid_x_min_from_value(value : float) -> float:
	return Rounder.floor_num_to_multiple(value - x_min, bin_width) + x_min

func _get_valid_y_min_from_value(value : float) -> float:
	return Rounder.floor_num_to_multiple(value - y_min, bin_height) + y_min

func _is_on_bin_edge(value : float) -> bool:
	return is_equal_approx(value, _get_valid_x_max_from_value(value))

func get_x_tick_count() -> int:
	return int(pair_of_axes.get_range().x / bin_width)

func get_y_tick_count() -> int:
	return int(pair_of_axes.get_range().y / bin_height)
