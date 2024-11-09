@tool
class_name Graph extends Control
## Base class for creating graphs. Should not be used directly. Use inheriting classes instead.

## Background color.
@export var color : Color = Color.BLACK:
	set(value):
		color = value
		color_rect.color = color
## Margin between graph and borders (on all sides) in px.
@export var border_margin : float = 10.0:
	set(value):
		border_margin = max(0, value)
		graph_v_box.set_offsets_preset(PRESET_FULL_RECT, PRESET_MODE_MINSIZE, border_margin)

@export_group("Titles")
## Title of the graph. Sets the [constant Label.text] property of [member graph_title]
@export_multiline var title : String = "":
	set(value):
		title = value
		if is_node_ready(): graph_title.text = value
		graph_title.visible = !title.is_empty()
## Font size multiplier applied on the graph title only.
@export_range(0, 10) var title_size : float = 1.0:
	set(value):
		title_size = value
		_on_theme_changed()
## Horizontal axis title.
@export var horizontal_title : String = "":
	set(value):
		horizontal_title = value
		if is_inside_tree(): x_axis_title.text = horizontal_title
		x_axis_title.visible = !horizontal_title.is_empty()
## Vertical axis title. Add a [Theme] and use [constant Theme.default_font_size] to control size.
@export var vertical_title : String = "":
	set(value):
		vertical_title = value
		if is_inside_tree(): y_axis_title.text = vertical_title
		y_axis_title.visible = !vertical_title.is_empty()
		_update_y_axis_title_rotation_and_position()
		queue_redraw()
## Rotate the vertical axis title. Add a [Theme] and use [constant Theme.default_font_size] to control size.
@export var rotated_v_title : bool = true:
	set(value):
		rotated_v_title = value
		_update_y_axis_title_rotation_and_position()
		queue_redraw()
## Font color. Applies to graph and axis titles.
@export var font_color : Color = Color.WHITE:
	set(value):
		font_color = value
		_set_label_colors(font_color)

@export_group("Axes")
## Color of both axes.
@export var axis_color : Color = Color.WHITE:
	set(value):
		axis_color = value
		x_axis.color = axis_color
		y_axis.color = axis_color
		queue_redraw()
## Sets thickness of both axes.
@export var axis_thickness: float = 3:
	set(value):
		axis_thickness = value
		x_axis.thickness = axis_thickness
		y_axis.thickness = axis_thickness
		queue_redraw()
## Font size multiplier applied to axis labels.
@export_range(0, 5) var label_size : float = 1.0:
	set(value):
		label_size = value
		x_axis.font_size = get_theme_font_size("", "") * label_size
		y_axis.font_size = get_theme_font_size("", "") * label_size
		_on_theme_changed()
## Allows ([member x_min], [member x_max]) and ([member y_min], [member y_max]) to dynamically change 
## to fit all data points. If not enabled, points lying outside the limits will be clipped.
@export var auto_scaling : bool = true:
	set(value):
		auto_scaling = value
		queue_redraw()
		
@export_group("X Axis", "x_")
## Minimun value on X-axis. Can be automatically decreased if auto-scaling is enabled. 
@export var x_min: float = 0.0:
	set(value):
		x_min = value
		if x_min > x_max: x_max = x_min
		queue_redraw()
## Maximum value on X-axis. Can be overriden if auto-scaling is enabled.
@export var x_max: float = 10.0:
	set(value):
		x_max = value
		if x_max < x_min: x_min = x_max
		queue_redraw()
## Number of ticks displayed on the x-axis.
@export var x_tick_count: int = 10:
	set(value):
		x_tick_count = value
		x_axis.num_ticks = x_tick_count
		queue_redraw()
## Show values on the ticks along the x-axis.
@export var x_tick_labels: bool = true:
	set(value):
		x_tick_labels = value
		x_axis.show_tick_labels = x_tick_labels
		queue_redraw()
## Number of decimal places shown on the x-axis tick labels.
@export_range(0, 5) var x_decimal_places : int = 1:
	set(value):
		x_decimal_places = value
		x_axis.decimal_places = x_decimal_places
		queue_redraw()
@export_subgroup("Gridlines", "x_gridlines")
## Control opacity of gridlines along the x-axis.
@export_range(0, 1) var x_gridlines_opacity : float = 1.0:
	set(value):
		x_gridlines_opacity = value
		queue_redraw()
## Set the thickness of the major gridlines
@export var x_gridlines_major_thickness : float = 1.0:
	set(value):
		x_gridlines_major_thickness = value
		x_gridlines.major_thickness = x_gridlines_major_thickness
		queue_redraw()
## Number of minor gridlines between each interval along the x-axis.
@export_range(0, 10) var x_gridlines_minor : int = 0:
	set(value):
		x_gridlines_minor = value
		x_gridlines.minor_count = x_gridlines_minor
		queue_redraw()
## Set the thickness of the minor gridlines
@export var x_gridlines_minor_thickness : float = 1.0:
	set(value):
		x_gridlines_minor_thickness = value
		x_gridlines.minor_thickness = x_gridlines_minor_thickness
		queue_redraw()

@export_group("Y Axis", "y_")
## Minimun value on y-axis. Can be overriden if auto-scaling is enabled.
@export var y_min: float = 0.0:
	set(value):
		y_min = value
		if y_min > y_max: y_max = y_min
		queue_redraw()
## Maximum value on y-axis. Can be overriden if auto-scaling is enabled.
@export var y_max: float = 10.0:
	set(value):
		y_max = value
		if y_max < y_min: y_min = y_max
		queue_redraw()
## Number of ticks displayed on the y-axis.
@export var y_tick_count: int = 10:
	set(value):
		y_tick_count = value
		y_axis.num_ticks = y_tick_count
		queue_redraw()
## Show values on the ticks along the y-axis.
@export var y_tick_labels: bool = true:
	set(value):
		y_tick_labels = value
		y_axis.show_tick_labels = y_tick_labels
		queue_redraw()
## Number of decimal places shown on the y-axis tick labels.
@export_range(0, 5) var y_decimal_places : int = 1:
	set(value):
		y_decimal_places = value
		y_axis.decimal_places = y_decimal_places
		queue_redraw()
@export_subgroup("Gridlines", "y_gridlines")
## Control opacity of gridlines along the y-axis.
@export_range(0, 1) var y_gridlines_opacity : float = 1.0:
	set(value):
		y_gridlines_opacity = value
		queue_redraw()
## Set the thickness of the major gridlines
@export var y_gridlines_major_thickness : float = 1.0:
	set(value):
		y_gridlines_major_thickness = value
		y_gridlines.major_thickness = y_gridlines_major_thickness
		queue_redraw()
## Number of minor gridlines between each interval along the y-axis.
@export_range(0, 10) var y_gridlines_minor : int = 0:
	set(value):
		y_gridlines_minor = value
		y_gridlines.minor_count = y_gridlines_minor
		queue_redraw()
## Set the thickness of the minor gridlines.
@export var y_gridlines_minor_thickness : float = 1.0:
	set(value):
		y_gridlines_minor_thickness = value
		y_gridlines.minor_thickness = y_gridlines_minor_thickness
		queue_redraw()

var color_rect := ColorRect.new() ## Background color.
var graph_v_box := VBoxContainer.new() ## Contains [member graph_title], [member graph_h_box], and [member x_axis_title].
var graph_title := Label.new() ## Graph title [Label].
var x_axis_title := Label.new() ## X Axis title [Label].
var y_axis_title := Label.new() ## Y Axis title [Label].
var chart_area := Control.new() ## A container for drawings created by inheriting classes. This is where graphical data is presented. 

var plotter : Plotter = Plotter.new(self)
var min_limits := Vector2(x_min, y_min) : 
	set(value):
		min_limits = value
		range = Vector2(max_limits.x - min_limits.x, max_limits.y - min_limits.y)
var max_limits := Vector2(x_max, y_max):
	set(value):
		max_limits = value
		range = Vector2(max_limits.x - min_limits.x, max_limits.y - min_limits.y)
var range := Vector2(x_max - x_min, y_max - y_min)
var x_axis := Axis.new()
var y_axis := Axis.new()
var x_gridlines := Gridlines.new(x_axis, y_axis)
var y_gridlines := Gridlines.new(y_axis, x_axis)
var chart_margin := {
	"top" : 0.0,
	"left": 0.0,
	"right": 0.0,
	"bottom": 0.0
	}

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build_graph()
	theme_changed.connect(_on_theme_changed)

func _build_graph():
	_build_background()
	_build_vbox()

func _build_background():
	add_child(color_rect)
	color_rect.color = color
	color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func _build_vbox():
	add_child(graph_v_box)
	graph_v_box.set_anchors_and_offsets_preset(PRESET_FULL_RECT, PRESET_MODE_MINSIZE, border_margin)
	graph_v_box.size_flags_horizontal = SIZE_EXPAND_FILL
	_build_graph_title()
	_build_chart_area()
	_build_x_axis_title()

func _build_graph_title():
	graph_v_box.add_child(graph_title)
	graph_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	graph_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	graph_title.text = title
	graph_title.visible = !title.is_empty()

func _build_chart_area():
	graph_v_box.add_child(chart_area)
	chart_area.resized.connect(queue_redraw)
	chart_area.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_build_y_axis_title()
	_build_axes()
	_build_gridlines()
	
	chart_area.add_child(plotter)
	plotter.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)

func _build_y_axis_title():
	chart_area.add_child(y_axis_title)
	_update_y_axis_title_rotation_and_position()
	y_axis_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	y_axis_title.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	y_axis.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	y_axis_title.text = vertical_title
	y_axis_title.visible = !vertical_title.is_empty()

func _update_y_axis_title_rotation_and_position():
	y_axis_title.size = y_axis_title.get_minimum_size()
	y_axis_title.pivot_offset = Vector2(y_axis_title.size.y/2, y_axis_title.size.y/2)
	if rotated_v_title:
		y_axis_title.rotation = -PI/2
		y_axis_title.position.y = chart_area.size.y/2 + y_axis_title.size.x/3.0
	else:
		y_axis_title.rotation = 0
		y_axis_title.position.y = chart_area.size.y/2

func _build_axes():
	chart_area.add_child(x_axis)
	x_axis.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	
	chart_area.add_child(y_axis)
	y_axis.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	y_axis.is_vertical = true
	
func _build_gridlines():
	chart_area.add_child(x_gridlines)
	x_gridlines.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	
	chart_area.add_child(y_gridlines)
	y_gridlines.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)

func _build_x_axis_title():
	graph_v_box.add_child(x_axis_title)
	x_axis_title.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	x_axis_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	x_axis_title.size_flags_vertical = SIZE_SHRINK_END
	x_axis_title.text = horizontal_title
	x_axis_title.visible = !horizontal_title.is_empty()

func _on_theme_changed():
	graph_title.add_theme_font_size_override("font_size", get_theme_font_size("", "") * title_size)
	if !is_node_ready(): return
	await get_tree().process_frame
	x_axis.font_size = get_theme_font_size("", "") * label_size
	y_axis.font_size = get_theme_font_size("", "") * label_size
	queue_redraw()
	
func _set_label_colors(label_color : Color) -> void:
	graph_title.add_theme_color_override("font_color", label_color)
	x_axis_title.add_theme_color_override("font_color", label_color)
	y_axis_title.add_theme_color_override("font_color", label_color)


func _draw() -> void:
	_update_chart_margin()
	_update_axes_origin_and_length()
	_update_gridline_color()
	
	x_axis.queue_redraw()
	y_axis.queue_redraw()
	x_gridlines.queue_redraw()
	y_gridlines.queue_redraw()

func _update_chart_margin():
	chart_margin.bottom = x_axis.tick_length * int(bool(x_tick_count))
	chart_margin.bottom += get_theme_font_size("", "") * label_size * int(x_tick_labels)
	chart_margin.bottom += axis_thickness
	
	chart_margin.left = y_axis.tick_length * int(bool(y_tick_count))
	chart_margin.left += get_theme_font_size("", "") * label_size * int(y_tick_labels)
	chart_margin.left += axis_thickness
	chart_margin.left += get_theme_font_size("", "") * label_size / 1.5 * (_get_max_num_of_digits(max_limits.y, min_limits.y) + y_decimal_places)
	chart_margin.left += _get_y_axis_title_width()
		
	chart_margin.right =  get_theme_font_size("", "") * label_size/3 * (floor(log(abs(x_max))) + x_decimal_places)
	chart_margin.top = _get_graph_title_height() / 2

func _get_y_axis_title_width() -> float:
	if rotated_v_title and y_axis_title.visible:
		return y_axis_title.size.y
	return y_axis_title.size.x

func _get_graph_title_height() -> float:
	return get_theme_font_size("", "") * title_size

func _get_max_num_of_digits(a, b):
	var max_num = max(abs(a), abs(b))
	return floor(log(max_num)/log(10))

func _update_axes_origin_and_length():
	x_axis.origin = Vector2(chart_margin.left, -chart_margin.bottom)
	y_axis.origin = Vector2(chart_margin.left, -chart_margin.bottom)
	x_axis.length = chart_area.size.x - (chart_margin.left + chart_margin.right)
	y_axis.length = chart_area.size.y - (chart_margin.bottom + chart_margin.top)

func _update_gridline_color():
	x_gridlines.color = Color(axis_color, x_gridlines_opacity)
	y_gridlines.color = Color(axis_color, y_gridlines_opacity)

func get_zero_position() -> Vector2:
	return x_axis.origin + x_axis.get_zero_position_offset() + y_axis.get_zero_position_offset()
