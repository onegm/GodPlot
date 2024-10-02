@tool
class_name Axis extends Control

@export_enum("Horizontal", "Vertical") var is_vertical : int = 0:
	set(value):
		is_vertical = value
		direction = Vector2.UP if is_vertical else Vector2.RIGHT
		out_direction = direction.rotated(PI/2 + is_vertical*PI)
		queue_redraw()
@export var length : float = 500.0:
	set(value):
		length = value
		tick_interval = length / float(num_ticks) if num_ticks else 0
		queue_redraw()
@export var thickness : float = 5.0:
	set(value):
		thickness = value
		tick_length = 2 * thickness
		queue_redraw()
@export var color : Color = Color.BLACK:
	set(value):
		color = value
		queue_redraw()
@export var num_ticks : int = 10:
	set(value):
		num_ticks = value
		tick_interval = length / float(num_ticks) if num_ticks else 0
		queue_redraw()
@export var min_value : float = 0:
	set(value):
		min_value = value
		queue_redraw()
@export var max_value : float = 10:
	set(value):
		max_value = value
		queue_redraw()
		
var direction : Vector2 = Vector2.RIGHT
var out_direction : Vector2 = Vector2.DOWN
var tick_interval : float = 0.0
var tick_length : float = 20.0
var margin : Vector2 = Vector2.ZERO

func _draw() -> void:
	draw_line(margin, margin + length * direction, color, thickness)
	draw_ticks()
	draw_tick_labels()
	
func draw_ticks() -> void:
	for i in range(num_ticks):
		var start = margin + tick_interval * direction*(i+1)
		draw_line(start , start + tick_length * out_direction,
				  get_theme_color("font_color"), thickness / 3)

func draw_tick_labels() -> void:
	if !num_ticks: return
	var axis_range = max_value - min_value
	for i in range(num_ticks + 1):
		var value = str(min_value + axis_range / num_ticks * i)
		var offset = calculate_string_offset(value.length())
		var start = margin + tick_interval * direction * i
		draw_string(get_theme_default_font(), start + offset, 
					value, HORIZONTAL_ALIGNMENT_LEFT, -1,
					get_theme_default_font_size(), get_theme_color("font_color"))

func calculate_string_offset(string_length : int) -> Vector2:
	var offset = out_direction * (tick_length + get_theme_default_font_size())
	if is_vertical:
		offset += out_direction * get_theme_default_font_size()/2 * (string_length - 1)
		offset -= direction * get_theme_default_font_size() / 3
	else:
		offset -= direction * get_theme_default_font_size() / 3.5 * string_length
	return offset
