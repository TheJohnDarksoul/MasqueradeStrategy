extends Node2D

@onready var Tilemap = $TileMapLayer
@onready var Char = $Char


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var click_position: Vector2 = get_global_mouse_position()
			var map_pos = Tilemap.local_to_map(to_local(click_position))
			
			if map_pos in Tilemap.get_used_cells():
				Char.position = Tilemap.map_to_local(map_pos)
