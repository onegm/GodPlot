extends GutTest

func test_find_min_with_floats():
	var result = MaxMinFinder.find_min(2.3, 1.2)
	assert_eq(result, 1.2)

func test_find_min_with_negative_floats():
	var result = MaxMinFinder.find_min(-2.3, -1.2)
	assert_eq(result, -2.3)

func test_find_min_with_vector2s():
	var result = MaxMinFinder.find_min(
		Vector2(5, 7.2), 
		Vector2(10.7, 3)
	)
	assert_eq(result, Vector2(5, 3))

func test_find_min_rejects_incompatible_types():
	var result = MaxMinFinder.find_min(
		Vector2(5, 7.2), 
		5.6
	)
	assert_null(result)
	
func test_find_min_accepts_compatible_types():
	var result = MaxMinFinder.find_min(
		Vector2(5, 7.2), 
		Vector2(5, 5)
	)
	assert_not_null(result)
	
func test_find_max_with_floats():
	var result = MaxMinFinder.find_max(2.3, 1.2)
	assert_eq(result, 2.3)

func test_find_max_with_negative_floats():
	var result = MaxMinFinder.find_max(-2.3, -1.2)
	assert_eq(result, -1.2)

func test_find_max_with_vector2s():
	var result = MaxMinFinder.find_max(
		Vector2(5, 7.2), 
		Vector2(10.7, 3)
	)
	assert_eq(result, Vector2(10.7, 7.2))

func test_find_max_rejects_incompatible_types():
	var result = MaxMinFinder.find_max(
		Vector2(5, 7.2), 
		5.6
	)
	assert_null(result)

func test_find_max_accepts_compatible_types():
	var result = MaxMinFinder.find_max(
		Vector2(5, 7.2), 
		Vector2(5, 5)
	)
	assert_not_null(result)
