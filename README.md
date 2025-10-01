# GodPlot
A Godot 4 plug-in for creating graphs. Works in the editor. The following graph types are supported:
- Scatter plots (circle, square, triangle, X, star)
- Line graphs
- Area graphs
- Histograms
- Heat Maps

## Example: 
![image](https://github.com/user-attachments/assets/802e9948-ab4a-478c-9842-6243ba98755a)
![image](https://github.com/user-attachments/assets/bb2eedf6-a28c-4c8a-8a12-dc7f6caac801)
![histogram_preview](https://github.com/user-attachments/assets/6667412d-f1d6-40c2-9db1-74da5e86cb28)
![image](https://github.com/user-attachments/assets/6327b906-348a-4711-96dd-047526f320a9)

Create a series

```GDScript
	scatter_series = ScatterSeries.new(Color.RED, 5.0, ScatterSeries.SHAPE.CIRCLE) # Defaults to circle. Square, Triangle, Star, and X available.   
	area_series = AreaSeries.new(Color(0, 0, 1, 0.5))
	line_series = LineSeries.new(Color.SEA_GREEN, 2.0)
	histogram_series = HistogramSeries.new(Color.BLUE)
	heat_map_series = HeatMapSeries.new()
```
Add series to a Graph2D and Histogram nodes
```GDScript
	graph_2d.add_series(scatter_series)
	graph_2d.add_series(area_series)	
	graph_2d.add_series(line_series)
	histogram.add_series(histogram_series)
	heat_map.add_series(heat_map_series)
```
Add data to series
```GDScript
	scatter_series.add_point_vector(Vector2.ONE * 10) # add_point() and add_point_vector() work on all 2D series
	area_series.add_point(x, sin(x)*5)
	line_series.add_point(x, sqrt(x)*5)
	histogram_series.add_point(randf_range(0, 100))
	heat_map_series.add_point_vector(Vector2(randfn(0, 15), randfn(0, 15)))
```
## Graph options
![graph_options](https://github.com/user-attachments/assets/8cff2d7f-158b-44d2-85b5-2fe64e9d0cd0)

## Scatter plot series options
![series_options](https://github.com/user-attachments/assets/7a9f8c7d-a58d-4637-9bfb-0123a08101bc)
