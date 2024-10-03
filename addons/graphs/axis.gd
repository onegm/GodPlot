@tool
class_name Axis extends Control

@export var is_vertical : bool = false:
	set(value):
		is_vertical = value
		direction = Vector2.UP if is_vertical else Vector2.RIGHT
		out_direction = Vector2.LEFT if is_vertical else Vector2.DOWN
		
@export var min_value : float = 0
@export var max_value : float = 10
@export var length : float = 500.0
@export var thickness : float = 5.0
@export var color : Color = Color.BLACK
@export var num_ticks : int = 10
		
var origin : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.RIGHT
var out_direction : Vector2 = Vector2.DOWN
var tick_interval : float = 0.0
var tick_length : float = 20.0
var show_tick_labels : bool = true
var decimal_places : int = 0

func _draw() -> void:
	draw_line(origin, origin + length * direction, color, thickness)
	draw_ticks()
	draw_tick_labels()
	
func draw_ticks() -> void:
	tick_length = 2 * thickness
	tick_interval = length / float(num_ticks) if num_ticks else 0
	for i in range(num_ticks):
		var start = origin + tick_interval * direction*(i+1)
		draw_line(start , start + tick_length * out_direction,
				  get_theme_color("font_color"), thickness / 3)

func draw_tick_labels() -> void:
	if !num_ticks or !show_tick_labels: return
	var axis_range = max_value - min_value
	for i in range(num_ticks + 1):
		var value = min_value + axis_range / num_ticks * i
		var str_value = "%0.*f" % [decimal_places, value]
		var offset = calculate_label_offset(str_value.length())
		var start = origin + tick_interval * direction * i
		draw_string(get_theme_default_font(), start + offset, 
					str_value, HORIZONTAL_ALIGNMENT_LEFT, -1,
					get_theme_default_font_size(), get_theme_color("font_color"))

func calculate_label_offset(string_length : int) -> Vector2:
	var offset = out_direction * (tick_length + get_theme_default_font_size())
	if is_vertical:
		offset += out_direction * get_theme_default_font_size()/2 * (string_length - 1)
		offset -= direction * get_theme_default_font_size() / 3
	else:
		offset -= direction * get_theme_default_font_size() / 3.5 * string_length
	return offset
