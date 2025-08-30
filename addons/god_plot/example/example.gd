extends Control

@onready var live_graph : Graph2D = %Graph2D
@onready var histogram : Histogram = %Histogram

@onready var scatter_series_square : ScatterSeries = %ScatterSeries
var scatter_series_x : ScatterSeries
var area_series : AreaSeries
var line_series : LineSeries
@onready var hist_series : HistogramSeries = %HistogramSeries
var hist_series_2 : HistogramSeries

@onready var heat_map_series : HeatMapSeries = %HeatMapSeries

var timer : Timer = Timer.new()
var x := 0.0

func _ready() -> void:
	live_graph.add_series(scatter_series_square)
	scatter_series_square.add_point(5, 0)
	
	scatter_series_x = ScatterSeries.new(Color.DARK_GOLDENROD, 5.0, ScatterSeries.SHAPE.X)
	live_graph.add_series(scatter_series_x)
	
	area_series = AreaSeries.new(Color(0, 0, 1, 0.5))
	live_graph.add_series(area_series)	
	
	line_series = LineSeries.new(Color.SEA_GREEN, 2.0)
	live_graph.add_series(line_series)
	
	
	histogram.add_series(hist_series)
	hist_series_2 = HistogramSeries.new(Color(Color.WHITE, 0.5))
	histogram.add_series(hist_series_2)
	hist_series_2.add_point(100.0)
	
	
	
	add_child(timer)
	timer.wait_time = 0.25
	timer.timeout.connect(add_points)
	timer.start()
	
func add_points():
	scatter_series_square.add_point_vector(Vector2(randf()*10-5, randf()*10-5))
	scatter_series_x.add_point(randf()*10, randf()*10)
	area_series.add_point(x, sin(x)*5)
	line_series.add_point(x, sqrt(x)*5)
	hist_series.add_point(randf_range(0, 10)**2) 
	hist_series_2.add_point(sqrt(randf_range(0, 10000)))
	heat_map_series.add_point_vector(Vector2(randfn(0, 20), randfn(0, 20)))
	x += 1/60.0
