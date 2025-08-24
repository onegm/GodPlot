@tool
class_name HeatMapSeries extends Series2D

var heat_map_binner : HeatMapBinner

func add_point(x : float, y : float) -> void:
	add_point_vector(Vector2(x, y))
	
func add_point_vector(point : Vector2) -> void:
	super.add_point_vector(point)
	heat_map_binner.bin_point(point)

func add_point_array(points : Array[Vector2]) -> void:
	super.add_point_array(points)
	points.map(heat_map_binner.bin_point)

func bin_data():
	heat_map_binner.bin_all_data(data)

func get_binned_data() -> Dictionary:
	var binned_data = heat_map_binner.get_binned_data()
	var keys = binned_data.keys()
	keys.sort()
	var result_dict = {}
	keys.map(func(key): result_dict[key] = binned_data[key])
	return result_dict

func remove_point(point : Vector2):
	super.remove_point(point)
	heat_map_binner.bin_all_data(data)

func set_data_from_Vector2_array(array : Array[Vector2]):
	set_data(PackedVector2Array(array))
	
func set_data(data_2D : PackedVector2Array):
	super.set_data(data_2D)
	heat_map_binner.bin_all_data(data)

func get_data() -> Array[float]:
	return data
