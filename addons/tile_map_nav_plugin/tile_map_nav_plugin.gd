@tool
extends EditorPlugin

var dock

func _enter_tree():
	var tnavregion = preload("tile_map_navigation_region2d.gd")
	add_custom_type("TileMapNavigationRegion2D", "NavigationRegion2D",\
			tnavregion, preload("tile_map_navigation_region2d.svg"))
	dock = preload("res://addons/tile_map_nav_plugin/dock.tscn").instantiate()
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, dock)
	dock.hide()


func _exit_tree():
	remove_custom_type("TileMapNavigationRegion2D")
	remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, dock)


func _handles(object:Object):
	return object is TileMapNavigationRegion2D\
		or object is TileMap


func _make_visible(visible: bool) -> void:
	dock.visible = visible
