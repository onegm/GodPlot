@tool
class_name Graph extends Control

enum TYPE{LINE_SCATTER, BAR, HISTOGRAM}
## Title of the graph.
@export var title : String:
	set(value):
		title = value
		if is_node_ready(): %Title.text = value
		
@export var background_color : Color:
	set(value):
		background_color = value
		if is_node_ready(): %Background.color = value

@onready var chart_area : Control = %ChartArea
