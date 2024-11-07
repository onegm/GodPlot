extends Control

@onready var live_graph : Graph2D = $VSplitContainer/HSplitContainer2/LiveGraph

var series_1 : ScatterSeries
var series_2 : AreaSeries

var timer : Timer = Timer.new()
var x := 0.0

func _ready() -> void:
	series_1 = live_graph.new_series(Series.TYPE.SCATTER, Color(1, 0, 0, 0.8), 5.0)
	series_2 = live_graph.new_series(Series.TYPE.AREA, Color(0, 0, 1, 0.5))
	
	timer.wait_time = 0.25
	timer.timeout.connect(add_point)
	add_child(timer)
	timer.start()
	
func add_point():
	series_1.add_point(Vector2(randf()*10, randf()*10))
	series_2.add_point(Vector2(x, sin(x + 6)*5))
	x += 1/60.0
