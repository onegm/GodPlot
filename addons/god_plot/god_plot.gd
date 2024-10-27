@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("Plot2D", "ColorRect", preload("tools/plot_2d.gd"), preload("icon.svg"))


func _exit_tree() -> void:
	remove_custom_type("Plot2D")
