extends NavigationRegion2D


#func _ready() -> void:
#	for occ in get_tree().get_nodes_in_group("navigation_occluder"):
#		cut_polygon(occ)


func cut_polygon(occluder: CollisionObject2D):
	var base_poly := Array(occluder.find_child("NavigationOccluder").polygon)
	var offset_poly = base_poly.map(func(it): return it + occluder.global_position)
	var outline_array = []
	for i in navigation_polygon.get_outline_count():
		if Geometry2D.is_polygon_clockwise(navigation_polygon.get_outline(i)):
			outline_array.push_front(navigation_polygon.get_outline(i))
		else:
			outline_array.append(navigation_polygon.get_outline(i))
	
	navigation_polygon.clear_outlines()
	
	for i in outline_array.size():
		var poly
		if Geometry2D.is_polygon_clockwise(outline_array[i]):
			printt(offset_poly, outline_array[i], !Geometry2D.intersect_polygons(outline_array[i], offset_poly).is_empty())
		if Geometry2D.is_polygon_clockwise(outline_array[i]) and not Geometry2D.intersect_polygons(outline_array[i], offset_poly).is_empty():
			poly = Geometry2D.merge_polygons(outline_array[i], offset_poly)
			offset_poly = poly[0]
		else:
			poly = Geometry2D.clip_polygons(outline_array[i], offset_poly)
			for it in poly:
				navigation_polygon.add_outline(it)
	
	navigation_polygon.make_polygons_from_outlines()
