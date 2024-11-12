extends Control

@onready var live_graph : Graph2D = $VSplitContainer/HSplitContainer2/LiveGraph

var series_1 : ScatterSeries
var series_2 : AreaSeries
var series_3 : LineSeries

var timer : Timer = Timer.new()
var x := 0.0

func _ready() -> void:
	series_1 = ScatterSeries.new(Color.RED, 5.0)
	live_graph.add_series(series_1)
	
	series_2 = AreaSeries.new(Color(0, 0, 1, 0.5))
	live_graph.add_series(series_2)	
	
	series_3 = LineSeries.new(Color.SEA_GREEN, 2.0)
	live_graph.add_series(series_3)
	
	add_child(timer)
	timer.wait_time = 0.25
	timer.timeout.connect(add_points)
	timer.start()
	
func add_points():
	series_1.add_point_vector(Vector2(randf()*10-5, randf()*10-5))
	series_2.add_point(x, sin(x)*5)
	series_3.add_point(x, sqrt(x)*5)
	x += 1/60.0
