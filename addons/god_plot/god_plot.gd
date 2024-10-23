@tool
extends EditorPlugin


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type("Plot2D", "ColorRect", preload("plot_2d.gd"), preload("res://addons/god_plot/icon.svg"))
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
