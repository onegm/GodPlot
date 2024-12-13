class_name GraphToAxesMapper


static func map_graph2d_to_pair_of_axes(graph : Graph2D, axes : PairOfAxes):
	_map_graph_to_axes(graph, axes)
	
	axes.set_num_ticks(Vector2i(graph.x_tick_count, graph.y_tick_count))
	axes.decimal_places = Vector2i(graph.x_decimal_places, graph.y_decimal_places)
	
	axes.x_gridlines.major_thickness = graph.x_gridlines_major_thickness
	axes.x_gridlines.minor_thickness = graph.x_gridlines_minor_thickness
	axes.x_gridlines.minor_count = graph.x_gridlines_minor
	axes.x_gridlines.color = Color(graph.axis_color, graph.x_gridlines_opacity)
	
	axes.y_gridlines.major_thickness = graph.y_gridlines_major_thickness
	axes.y_gridlines.minor_thickness = graph.y_gridlines_minor_thickness
	axes.y_gridlines.minor_count = graph.y_gridlines_minor
	axes.y_gridlines.color = Color(graph.axis_color, graph.y_gridlines_opacity)
	
static func map_histogram_to_pair_of_axes(histogram : Histogram, axes : PairOfAxes):
	_map_graph_to_axes(histogram, axes)
	
	axes.set_num_ticks(Vector2i(histogram.get_x_tick_count(), histogram.y_tick_count))
	axes.decimal_places = Vector2i(histogram.x_decimal_places, histogram.y_decimal_places)

	axes.x_gridlines.major_thickness = histogram.x_gridlines_major_thickness
	axes.x_gridlines.color = Color(histogram.axis_color, histogram.x_gridlines_opacity)
	
	axes.y_gridlines.major_thickness = histogram.y_gridlines_major_thickness
	axes.y_gridlines.minor_thickness = histogram.y_gridlines_minor_thickness
	axes.y_gridlines.minor_count = histogram.y_gridlines_minor
	axes.y_gridlines.color = Color(histogram.axis_color, histogram.y_gridlines_opacity)

static func _map_graph_to_axes(graph : Graph, axes : PairOfAxes):
	axes.set_label_visibility(graph.show_tick_labels)
	axes.set_font_and_size(
		graph.get_theme_font(""), 
		graph.get_theme_font_size("") * graph.label_size
		)
	axes.color = graph.axis_color
	axes.thickness = graph.axis_thickness
	axes.y_title_margin = graph.get_y_axis_title_width()
