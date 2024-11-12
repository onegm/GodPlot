@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("Graph2D", "Control", preload("tools/graphs/graph_2d.gd"), preload("icon.svg"))
	add_custom_type("ScatterSeries", "Node", preload("tools/series/series_types/scatter_series.gd"), preload("icon.svg"))
	add_custom_type("LineSeries", "Node", preload("tools/series/series_types/line_series.gd"), preload("icon.svg"))
	add_custom_type("AreaSeries", "Node", preload("tools/series/series_types/area_series.gd"), preload("icon.svg"))


func _exit_tree() -> void:
	remove_custom_type("Graph2D")
	remove_custom_type("ScatterSeries")
	remove_custom_type("LineSeries")
	remove_custom_type("AreaSeries")
