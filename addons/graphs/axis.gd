@tool
class_name Axis extends Control

@export_enum("Horizontal", "Vertical") var orientation : int:
	set(value):
		orientation = value
		direction = Vector2.UP if orientation else Vector2.RIGHT
		queue_redraw()
@export var length : float = 500.0:
	set(value):
		length = value
		tick_interval = length / float(num_ticks) if num_ticks else 0
		queue_redraw()
@export var thickness : float = 10.0:
	set(value):
		thickness = value
		tick_length = 2 * thickness
		queue_redraw()
@export var color : Color = Color.RED:
	set(value):
		color = value
		queue_redraw()
@export var num_ticks : int:
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
var tick_interval : float = 0.0
var tick_length : float = 20.0

func _draw() -> void:
	draw_line(Vector2.ZERO, Vector2.ZERO + length * direction, color, thickness)
	draw_ticks()
	draw_tick_labels()
	
func draw_ticks() -> void:
	var tick_direction = direction.rotated(PI/2 + orientation*PI)
	for i in range(num_ticks):
		var start = Vector2.ZERO + tick_interval * direction*(i+1)
		draw_line(start , start + tick_length * tick_direction,
				  get_theme_color("font_color"), thickness / 3)

func draw_tick_labels() -> void:
	var axis_range = max_value - min_value
	var perpendicular_offset = direction.rotated(PI/2 + orientation*PI) * tick_length * 2
	for i in range(num_ticks + 1):
		var value = str(min_value + axis_range / num_ticks * i)
		var offset = perpendicular_offset - direction * get_theme_default_font_size() / 3.5 * (1 + (value.length()-1)*orientation)
		var start = Vector2.ZERO + tick_interval * direction * i
		draw_string(get_theme_default_font(), start + offset, 
					value, HORIZONTAL_ALIGNMENT_LEFT, -1,
					get_theme_default_font_size(), get_theme_color("font_color"))
		
