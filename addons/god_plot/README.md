# GodPlot
A Godot 4 plug-in for creating graphs. Works in the editor. The following graph types are supported:
- Scatter plots
- Line graphs
- Area graphs

## Example: 
![image](https://github.com/user-attachments/assets/802e9948-ab4a-478c-9842-6243ba98755a)


Create a series
```GDScript
	series_1 = ScatterSeries.new(Color.RED, 5.0)
	series_2 = AreaSeries.new(Color(0, 0, 1, 0.5))
	series_3 = LineSeries.new(Color.SEA_GREEN, 2.0)
```
Add series to a Graph2D node
```GDScript
	graph_2d.add_series(series_1)
	graph_2d.add_series(series_2)	
	graph_2d.add_series(series_3)
```
Add data to series
```GDScript
	series_1.add_point_vector(Vector2.ONE * 10)
	series_2.add_point(x, sin(x)*5)
	series_3.add_point(x, sqrt(x)*5)
```
