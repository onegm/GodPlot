extends Control

@onready var live_graph : Graph2D = $VSplitContainer/HSplitContainer2/LiveGraph

var series_1 : ScatterSeries
var series_2 : AreaSeries

var timer : Timer = Timer.new()
var x := 0.0

func _ready() -> void:
	series_1 = ScatterSeries.new( Color(1, 0, 0, 0.8), 5.0)
	live_graph.add_series(series_1)
	
	series_2 = AreaSeries.new(Color(0, 0, 1, 0.5))
	live_graph.add_series(series_2)
	
	timer.wait_time = 0.25
	timer.timeout.connect(add_random_point)
	add_child(timer)
	timer.start()
	
func add_random_point():
	series_1.add_point(Vector2(randf()*10-5, randf()*10-5))
	series_2.add_point(Vector2(x, sin(x + 3)*5))
	x += 1/60.0

func remove_point():
	if series_1.data.size() < 10: return
	series_1.remove_point(series_1.data[0])
