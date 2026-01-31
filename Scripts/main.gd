extends Node2D

@onready var Tilemap = $TileMapLayer
@onready var Char = $Char


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var click_position: Vector2 = get_global_mouse_position()
			print("Mouse clicked at: ", click_position)
			
			# You can then use this position to move an object or perform actions
			# For example:
			# position = click_position 
			
			
			
			var map_pos = Tilemap.local_to_map(to_local(click_position))
		
			# 3. Get cell data (e.g., Source ID, Atlas Coords)
			#var source_id = Tilemap.get_cell_source_id(0, map_pos)
			#var atlas_coords = Tilemap.get_cell_atlas_coords(0, map_pos)
			
			
			Char.position = Tilemap.map_to_local(map_pos)
