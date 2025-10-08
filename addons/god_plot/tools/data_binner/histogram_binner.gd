class_name HistogramBinner extends Node

var histogram_series : HistogramSeries
var binned_data : Dictionary = {}
var outlier_behavior : Histogram.OUTLIER

func _init(histogram_series : HistogramSeries) -> void:
	self.histogram_series = histogram_series

func get_binned_data() -> Dictionary:
	binned_data.clear()
	var data = _get_data_adjusted_for_outlier_behavior()
	data.map(bin_value)
	return binned_data

func _get_data_adjusted_for_outlier_behavior():
	if outlier_behavior == Histogram.OUTLIER.INCLUDE:
		return histogram_series.data.map(clamp_value_to_min_max)
	return histogram_series.data

func clamp_value_to_min_max(value : float) -> float:
	return clamp(
		value, 
		histogram_series.x_min,
		histogram_series.x_max - histogram_series.bin_size / 2.0
		)

func bin_value(value : float) -> int:
	var bin_num = get_bin_num(value)
	increment_bin_num(bin_num)
	return bin_num

func get_bin_num(value : float) -> int:
	return floor((value - histogram_series.x_min) / histogram_series.bin_size)

func increment_bin_num(bin_num : int):
	if binned_data.has(bin_num):
		binned_data[bin_num] += 1
	else:
		binned_data[bin_num] = 1
