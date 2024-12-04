# GodPlot
A Godot 4 plug-in for creating graphs. Works in the editor. The following graph types are supported:
- Scatter plots (circle, square, triangle, X, star)
- Line graphs
- Area graphs

## Example: 
![image](https://github.com/user-attachments/assets/802e9948-ab4a-478c-9842-6243ba98755a)
![image](https://github.com/user-attachments/assets/bb2eedf6-a28c-4c8a-8a12-dc7f6caac801)


Create a series
```GDScript
	series_1 = ScatterSeries.new(Color.RED, 5.0, ScatterSeries.SHAPE.CIRCLE) # Defaults to circle. Square, Triangle, Star, and X available.   
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
## Graph options
![graph_options](https://github.com/user-attachments/assets/8cff2d7f-158b-44d2-85b5-2fe64e9d0cd0)

## Scatter plot series options
![series_options](https://github.com/user-attachments/assets/7a9f8c7d-a58d-4637-9bfb-0123a08101bc)
