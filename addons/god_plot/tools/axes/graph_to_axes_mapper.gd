class_name GraphToAxesMapper

static func map(graph : Graph2D, axes : PairOfAxes):
	axes.set_min_limits(graph.min_limits)
	axes.set_max_limits(graph.max_limits)
	axes.set_font_and_size(
		graph.get_theme_font("", ""), 
		graph.get_theme_font_size("", "") * graph.label_size
		)
	axes.color = graph.axis_color
	axes.thickness = graph.axis_thickness
	axes.visible_tick_labels = graph.show_tick_labels
	axes.num_ticks = Vector2i(graph.x_tick_count, graph.y_tick_count)
	axes.decimal_places = Vector2i(graph.x_decimal_places, graph.y_decimal_places)
	
	axes.x_gridlines.major_thickness = graph.x_gridlines_major_thickness
	axes.x_gridlines.minor_thickness = graph.x_gridlines_minor_thickness
	axes.x_gridlines.minor_count = graph.x_gridlines_minor
	axes.x_gridlines.color = Color(graph.axis_color, graph.x_gridlines_opacity)
	
	axes.y_gridlines.major_thickness = graph.y_gridlines_major_thickness
	axes.y_gridlines.minor_thickness = graph.y_gridlines_minor_thickness
	axes.y_gridlines.minor_count = graph.y_gridlines_minor
	axes.y_gridlines.color = Color(graph.axis_color, graph.y_gridlines_opacity)
	axes.y_title_margin = graph.get_y_axis_title_width()
	
