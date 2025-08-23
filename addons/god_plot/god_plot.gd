@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("Graph2D", "Control", preload("tools/graphs/graph_2d.gd"), preload("icons/graph_2d.svg"))
	add_custom_type("ScatterSeries", "Node", preload("tools/series/series_types/series_2d/scatter_series.gd"), preload("icons/scatter_series.svg"))
	add_custom_type("LineSeries", "Node", preload("tools/series/series_types/series_2d/line_series.gd"), preload("icons/line_series.svg"))
	add_custom_type("AreaSeries", "Node", preload("tools/series/series_types/series_2d/area_series.gd"), preload("icons/area_series.svg"))
	
	add_custom_type("Histogram", "Control", preload("tools/graphs/histogram.gd"), preload("icons/histogram.svg"))
	add_custom_type("HistogramSeries", "Node", preload("tools/series/series_types/histogram_series.gd"), preload("icons/histogram_series.svg"))
		
	add_custom_type("HeatMap", "Control", preload("tools/graphs/heat_map.gd"), preload("icons/histogram.svg"))
	add_custom_type("HeatMapSeries", "Node", preload("tools/series/series_types/series_2d/heat_map_series.gd"), preload("icons/histogram_series.svg"))

func _exit_tree() -> void:
	remove_custom_type("Graph2D")
	remove_custom_type("ScatterSeries")
	remove_custom_type("LineSeries")
	remove_custom_type("AreaSeries")

	remove_custom_type("Histogram")
	remove_custom_type("HistogramSeries")
