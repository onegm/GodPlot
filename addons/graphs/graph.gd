@tool
class_name Graph extends Control

enum TYPE{LINE_SCATTER, BAR, HISTOGRAM}
## Graph background color
@export var background_color : Color = Color.WHITE:
	set(value):
		background_color = value
		if is_node_ready(): background.color = value
## Title of the graph.
@export var title : String = "":
	set(value):
		title = value
		if is_node_ready(): graph_title.text = value
## Horizontal axis title. 
@export var h_axis_title : String = "":
	set(value):
		h_axis_title = value
		if is_inside_tree(): x_axis_title.text = value
## Vertical axis title. 
@export var v_axis_title : String = "":
	set(value):
		v_axis_title = value
		if is_inside_tree(): y_axis_title.text = value

var background := ColorRect.new()
var graph_v_box := VBoxContainer.new()
var graph_title := Label.new()
var graph_h_box := HBoxContainer.new()
var x_axis_title := Label.new()
var y_axis_title := Label.new()
var chart_area := Control.new()

func _ready() -> void:
	add_child(background)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.color = background_color
	background.z_index = -1
	
	add_child(graph_v_box)
	graph_v_box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 80)
	graph_v_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	graph_v_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	graph_v_box.add_child(graph_title)
	graph_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	graph_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	graph_title.text = "AAAAAA"
	graph_v_box.add_child(graph_h_box)
	graph_h_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	graph_v_box.add_child(x_axis_title)
	x_axis_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	x_axis_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	x_axis_title.text = "BBBB"
	
	graph_h_box.add_child(y_axis_title)
	y_axis_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	y_axis_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	y_axis_title.text = "CCCCC"
	
	graph_h_box.add_child(chart_area)
	chart_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
