extends Node2D

@onready var Tilemap = $TileMapLayer
@onready var Char = $Unit

var movement = 2


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var click_position: Vector2 = get_global_mouse_position()
			var map_pos = Tilemap.local_to_map(to_local(click_position))
			var char_pos = Tilemap.local_to_map(to_local(Char.position))
			
			if map_pos in Tilemap.get_used_cells():
				Char.position = Tilemap.map_to_local(map_pos)
			
			
			
			#var validCells = Tilemap.get_surrounding_cells(char_pos)
			#if movement == 1:
				#pass
			#else:
				#for i in range(movement - 1):
					#for c in validCells:
						#var newcells = Tilemap.get_surrounding_cells(c)
						#for n in newcells:
							#if not validCells.has(n):
								#validCells.append(n)
				#
			#
			#if map_pos in Tilemap.get_used_cells() and map_pos in validCells:
				#Char.position = Tilemap.map_to_local(map_pos)
				#print("1")
				#Char.global_position = Char.global_position.move_toward(Tilemap.map_to_local(map_pos), 3 * 1)
			#else:
				#print("2")
