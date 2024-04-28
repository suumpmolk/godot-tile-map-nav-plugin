@tool
extends Control


func _on_button_pressed():
	if not EditorInterface.has_method("get_selection"):
		# Editor is not up
		return
	var editor_selection = EditorInterface.get_selection()
	var selected_nodes = editor_selection.get_selected_nodes()
	if selected_nodes.size() == 1:
		var selected_node = selected_nodes[0]
		if selected_node is TileMapNavigationRegion2D:
			bake_tile_map_navigation_region2d(selected_node)
		elif selected_node is TileMap:
			bake_all_using_tile_map(selected_node)


func bake_all_using_tile_map(tile_map: TileMap):
	var polygons = get_tile_map_polygons(tile_map)
	var root = EditorInterface.get_edited_scene_root()
	for child in root.get_children():
		var regions = root.find_children("*", "TileMapNavigationRegion2D")
		for region in regions:
			if region.tile_maps.has(tile_map):
				var nav_data = NavigationMeshSourceGeometryData2D.new()
				NavigationServer2D.parse_source_geometry_data(region.navigation_polygon, nav_data, region)
				for polygon in polygons:
					nav_data.add_obstruction_outline(polygon)
				NavigationServer2D.bake_from_source_geometry_data_async(region.navigation_polygon, nav_data, _post_baking.bind(region))


func bake_tile_map_navigation_region2d(region: TileMapNavigationRegion2D):
	var nav_data = NavigationMeshSourceGeometryData2D.new()
	NavigationServer2D.parse_source_geometry_data(region.navigation_polygon, nav_data, region)
	for tile_map in region.tile_maps:
		var polygons = get_tile_map_polygons(tile_map)
		for polygon in polygons:
			nav_data.add_obstruction_outline(polygon)
	NavigationServer2D.bake_from_source_geometry_data_async(region.navigation_polygon, nav_data, _post_baking.bind(region))


func get_tile_map_polygons(tile_map: TileMap) -> Array:
	var polygons = []
	var physics_layers = tile_map.tile_set.get_physics_layers_count()
	for layer in tile_map.get_layers_count():
		var cells = tile_map.get_used_cells(layer)
		for cell in cells:
			var tile_data = tile_map.get_cell_tile_data(layer, cell)
			if tile_data != null:
				var tile_pos = tile_map.to_global(tile_map.map_to_local(cell))
				for physics_layer in physics_layers:
					for polygon_index in tile_data.get_collision_polygons_count(physics_layer):
						var points = tile_data.get_collision_polygon_points(physics_layer, polygon_index)
						var converted_points = []
						for p in points:
							converted_points.append(p + tile_pos)
						polygons.append(converted_points)
	return polygons


func _post_baking(region):
	region.queue_redraw()
