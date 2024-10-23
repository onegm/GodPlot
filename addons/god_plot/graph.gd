@tool
class_name Graph extends ColorRect

## Base class for creating graphs. Should not be used directly. Use inheriting classes instead.

## Font size multiplier applied on the graph title only. Control the axis title size
## by adding a [Theme] and setting the [constant Theme.default_font_size].
@export_range(0, 10) var title_size : float = 1.0:
	set(value):
		title_size = value
		_on_theme_changed()
## Font color. Applies to graph and axis titles.
@export var font_color : Color = Color.BLACK:
	set(value):
		font_color = value
		set_label_colors(font_color)
## Margin between graph and borders (on all sides) in px. Use [MarginContainer] 
## as node parent with [member margin] set to 0 for custom margins. 
@export var margin : float = 10.0:
	set(value):
		margin = value
		graph_v_box.set_offsets_preset(PRESET_FULL_RECT, PRESET_MODE_MINSIZE, margin)
## Title of the graph. Sets the [constant Label.text] property of [member graph_title]
@export_multiline var title : String = "":
	set(value):
		title = value
		if is_node_ready(): graph_title.text = value
		graph_title.visible = !title.is_empty()
## Horizontal axis title. Sets the [constant Label.text] property of [member x_axis_title]
@export_multiline var h_axis_title : String = "":
	set(value):
		h_axis_title = value
		if is_inside_tree(): x_axis_title.text = value
		x_axis_title.visible = !h_axis_title.is_empty()
## Vertical axis title. Sets the [constant Label.text] property of [member y_axis_title]
@export_multiline var v_axis_title : String = "":
	set(value):
		v_axis_title = value
		if is_inside_tree(): y_axis_title.text = value
		y_axis_title.visible = !v_axis_title.is_empty()

var graph_v_box := VBoxContainer.new() ## Contains [member graph_title], [member graph_h_box], and [member x_axis_title].
var graph_title := Label.new() ## Graph title [Label].
var graph_h_box := HBoxContainer.new() ## Contains [member y_axis_title], and [member chart_area].
var x_axis_title := Label.new() ## X Axis title [Label].
var y_axis_title := Label.new() ## Y Axis title [Label].
var chart_area := Control.new() ## A container for drawings created by inheriting classes. This is where graphical data is presented. 

func _ready() -> void:
	color = Color.WEB_GRAY
	theme_changed.connect(_on_theme_changed)
	
	add_child(graph_v_box)
	graph_v_box.set_anchors_and_offsets_preset(PRESET_FULL_RECT, PRESET_MODE_MINSIZE, margin)
	graph_v_box.size_flags_horizontal = SIZE_EXPAND_FILL
	graph_v_box.size_flags_vertical = SIZE_EXPAND_FILL
	
	graph_v_box.add_child(graph_title)
	graph_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	graph_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	graph_title.visible = false
	
	graph_v_box.add_child(graph_h_box)
	graph_h_box.size_flags_vertical = SIZE_EXPAND_FILL
	
	graph_v_box.add_child(x_axis_title)
	x_axis_title.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	x_axis_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	x_axis_title.size_flags_vertical = SIZE_SHRINK_END
	x_axis_title.visible = false
	
	graph_h_box.add_child(y_axis_title)
	y_axis_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	y_axis_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	y_axis_title.visible = false
	
	graph_h_box.add_child(chart_area)
	chart_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	chart_area.resized.connect(queue_redraw)
	
	await get_tree().process_frame
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func set_label_colors(label_color : Color) -> void:
	graph_title.add_theme_color_override("font_color", label_color)
	x_axis_title.add_theme_color_override("font_color", label_color)
	y_axis_title.add_theme_color_override("font_color", label_color)
	

func _on_theme_changed():
	## Sets [member graph_title]'s font_size according to [member title_size] and [constant Theme.default_font_size].
	## Connected to the [signal Control.theme_changed] signal.
	graph_title.add_theme_font_size_override("font_size", get_theme_font_size("", "") * title_size)
