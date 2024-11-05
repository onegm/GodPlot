extends GutTest

var plot_data : PlotData
var scatter_example : PlotData 
var line_example : PlotData 
var area_example : PlotData 

func before_all():
	scatter_example = PlotData.new(Series.TYPE.SCATTER, Color.BLUE, 3.0)
	scatter_example.add_point(Vector2(0, 0))
	
	line_example = PlotData.new(Series.TYPE.LINE, Color.RED, 5.0)
	
	area_example = PlotData.new(Series.TYPE.AREA, Color.BLACK)
	area_example.add_point(Vector2(0,0)).add_point(Vector2(1,1)).add_point(Vector2(2,2))
	
func test_scatter_constructor():
	plot_data = PlotData.new_scatter_point(Vector2(0,0), Color.BLUE, 3.0)
	assert_true(plot_data.equals(scatter_example))

func test_line_constructor():
	plot_data = PlotData.new_line(Color.RED, 5.0)
	assert_true(plot_data.equals(line_example))

func test_area_constructor():
	plot_data = PlotData.new_area(PackedVector2Array([
		Vector2(0,0),
		Vector2(1,1),
		Vector2(2,2)
	]), Color.BLACK)
	assert_true(plot_data.equals(area_example))

func test_add_point_to_scatter():
	pending()
	
func test_add_point_to_line_and_area():
	pending()
