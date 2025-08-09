extends GutTest

func test_can_make_one():
	var heatmap = HeatMap.new()
	assert_not_null(heatmap)
	heatmap.free()


func test_draw_signal_emitted_once_after_set_x_max():
	var heatmap = HeatMap.new()
	add_child_autofree(heatmap)
	watch_signals(heatmap)
	await wait_seconds(0.1)
	var original_count = get_signal_emit_count(heatmap, "draw")
	heatmap.x_max = 20
	await wait_seconds(0.1)
	assert_signal_emit_count(heatmap, "draw", original_count + 1)
