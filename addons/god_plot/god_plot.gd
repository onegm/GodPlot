@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("Graph2D", "Control", preload("tools/graph_2d.gd"), preload("icon.svg"))


func _exit_tree() -> void:
	remove_custom_type("Plot2D")
