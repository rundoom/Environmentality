extends NavigationRegion2D


#func _ready() -> void:
#	for occ in get_tree().get_nodes_in_group("navigation_occluder"):
#		cut_polygon(occ)


func cut_polygon(occluder: CollisionObject2D):
	var base_poly := Array(occluder.find_child("NavigationOccluder").polygon)
	var offset_poly = base_poly.map(func(it): return it + occluder.global_position)
	
	for i in navigation_polygon.get_outline_count():
		var poly = Geometry2D.clip_polygons(navigation_polygon.get_outline(i), offset_poly)

		navigation_polygon.set_outline(i, poly[0])
		if poly.size() == 2:
			navigation_polygon.add_outline(poly[1])
	
	navigation_polygon.make_polygons_from_outlines()
