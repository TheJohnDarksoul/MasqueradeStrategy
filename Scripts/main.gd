extends Node2D

@onready var Tilemap: TileMapLayer = $TileMapLayer
@onready var highlight_map: TileMapLayer = $HighlightMap
@onready var char

var astar := AStar2D.new()


var mvt_setup = false

var char_to_act = []
var start_cell

enum GameState {
	BEGIN_TURN,
	SELECTING,
	CHOOSING,
	MOVING,
	ATTACKING,
	ENEMY_TURN,
}
var current_state: GameState = GameState.BEGIN_TURN


func _ready() -> void:
	highlight_map.visible = true
	highlight_map.modulate = Color(0.115, 0.69, 0.0, 0.38)
	rebuild_pathfinding(Tilemap)


func _process(delta):
	if current_state == GameState.MOVING:
		if mvt_setup == true:
			start_cell = Tilemap.local_to_map(Tilemap.to_local(char.global_position))
			var reachable = get_reachable_cells(start_cell, char.unitClass.movement)
			highlight_reachable(reachable)
			mvt_setup = false
			
	if current_state == GameState.ATTACKING:
		if mvt_setup == true:
			rebuild_pathfinding_attack(Tilemap)
			start_cell = Tilemap.local_to_map(Tilemap.to_local(char.global_position))
			var reachable = get_reachable_cells(start_cell, char.inventory[0].weaponRange)
			highlight_reachable(reachable)
			mvt_setup = false
			
			
	if current_state == GameState.BEGIN_TURN:
		char_to_act.append_array(get_friendly_units())
		print(char_to_act)
		current_state = GameState.SELECTING
		
	
		
		
		
		
		
		
		
		
		
		
			
			
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if current_state == GameState.MOVING:
				
				var click_pos := get_global_mouse_position()
				var target_cell := Tilemap.local_to_map(Tilemap.to_local(click_pos))
				
				if not target_cell in Tilemap.get_used_cells():
					return

				start_cell = Tilemap.local_to_map(Tilemap.to_local(char.global_position))
				var path := find_path(Tilemap, start_cell, target_cell)

				# Path must exist and be within movement range
				if path.is_empty():
					return

				var steps := path.size() - 1
				if steps <= char.unitClass.movement:
					# Move to final tile (for now: instant move)
					char.global_position = path[-1]
					rebuild_pathfinding(Tilemap)
					highlight_map.clear()
					char_to_act.erase(char)
					current_state = GameState.SELECTING
					
					
			elif current_state == GameState.SELECTING:
				if len(char_to_act) == 0:
					current_state = GameState.ENEMY_TURN
					doEnemyTurns()
					current_state = GameState.BEGIN_TURN
				
				var click_pos := get_global_mouse_position()
				var target_cell := Tilemap.local_to_map(Tilemap.to_local(click_pos))
				var units = get_unit_and_location()
				
				for u in units:
					if target_cell == u[1]:
						if u[0].army == 0 and u[0] in char_to_act:
							char = u[0]
							globs.selectedPlayer = u[0]
							rebuild_pathfinding(Tilemap)
							mvt_setup = true
							current_state = GameState.CHOOSING
						
			elif current_state == GameState.ATTACKING:
				
				var click_pos := get_global_mouse_position()
				var target_cell := Tilemap.local_to_map(Tilemap.to_local(click_pos))
				
				if not target_cell in Tilemap.get_used_cells():
					return

				start_cell = Tilemap.local_to_map(Tilemap.to_local(char.global_position))
				var path := find_path(Tilemap, start_cell, target_cell)

				var all = get_unit_and_location()
				var got_enemy = false
				var enemy
				for u in all:
					if target_cell == u[1] and u[0].army != 0:
						enemy = u[0]
						print("Got enemy")
						got_enemy = true
				
				if got_enemy == false:
					print("Did not get enemy")
					return

				# Path must exist and be within movement range
				if path.is_empty():
					print("Did not get path for enemy")
					return
					
				var steps := path.size() - 1
				if steps <= char.inventory[0].weaponRange:
					print("attacked enemy")
					# DO ATTACK STUFF HERE __________________________________________________
					enemy.takeDamage(char.calcDamage())
					print("Enemy took " , char.calcDamage() , " damage")
				
					highlight_map.clear()
					char_to_act.erase(char)
					current_state = GameState.SELECTING
						
						
						
						
	if event is InputEventKey:
		if current_state == GameState.CHOOSING:
			if event.keycode == KEY_A and event.pressed:
				print("Changed to Attacking")
				current_state = GameState.ATTACKING
			if event.keycode == KEY_M and event.pressed:
				print("Changed to Moving")
				current_state = GameState.MOVING
			if event.keycode == KEY_E and event.pressed:
				print("Changed to Enemy Turn")
				char_to_act = []
				mvt_setup == false
				current_state = GameState.ENEMY_TURN
				doEnemyTurns()
				current_state = GameState.BEGIN_TURN

func build_astar(tilemap: TileMapLayer) -> void:
	astar.clear()

	for cell in tilemap.get_used_cells():
		if cell in get_unit_cells():
			continue

		var id := cell_to_id(cell)
		var world_pos := tilemap.map_to_local(cell)
		astar.add_point(id, world_pos)
		
func build_astar2(tilemap: TileMapLayer) -> void:
	astar.clear()

	for cell in tilemap.get_used_cells():

		var id := cell_to_id(cell)
		var world_pos := tilemap.map_to_local(cell)
		astar.add_point(id, world_pos)


func connect_neighbors(tilemap: TileMapLayer) -> void:
	for cell in tilemap.get_used_cells():
		var id := cell_to_id(cell)
		if not astar.has_point(id):
			continue

		for neighbor in tilemap.get_surrounding_cells(cell):
			var nid := cell_to_id(neighbor)
			if astar.has_point(nid):
				astar.connect_points(id, nid, false)


func rebuild_pathfinding(tilemap: TileMapLayer) -> void:
	build_astar(tilemap)
	connect_neighbors(tilemap)

func rebuild_pathfinding_attack(tilemap: TileMapLayer) -> void:
	build_astar2(tilemap)
	connect_neighbors(tilemap)

func find_path(tilemap: TileMapLayer, start_cell: Vector2i, end_cell: Vector2i) -> PackedVector2Array:
	var start_id := cell_to_id(start_cell)
	var end_id := cell_to_id(end_cell)

	if not astar.has_point(start_id) or not astar.has_point(end_id):
		return PackedVector2Array()

	return astar.get_point_path(start_id, end_id)


func cell_to_id(cell: Vector2i) -> int:
	return (cell.x << 16) | (cell.y & 0xFFFF)


func is_blocked(cell: Vector2i) -> bool:
	var data := Tilemap.get_cell_tile_data(cell)
	if data == null:
		return true
	return data.get_custom_data("blocked") == true
	
	
func get_reachable_cells(start_cell: Vector2i, max_movement: int) -> Array[Vector2i]:
	var start_id := cell_to_id(start_cell)
	var reachable: Array[Vector2i] = []

	for cell in Tilemap.get_used_cells():
		var nid := cell_to_id(cell)
		if not astar.has_point(nid):
			continue

		var path := astar.get_point_path(start_id, nid)
		if path.size() == 0:
			continue

		var steps := path.size() - 1
		# DO TILE MVT HERE
		if steps <= max_movement:
			reachable.append(cell)

	return reachable
	
	
func highlight_reachable(reachable_cells: Array[Vector2i]) -> void:
	highlight_map.clear()  # Remove previous highlights

	for cell in reachable_cells:
		highlight_map.set_cell(cell, 1, Vector2i(0, 0))
		
		
func get_unit_cells():
	var units = get_tree().get_nodes_in_group("units")
	var cells = []
	for u in units:
		# Skip the current character unit
		if u == char:
			continue
		var global = u.global_position
		var cell = Tilemap.local_to_map(Tilemap.to_local(global))
		cells.append(cell)
	return cells
	
func get_friendly_units():
	var units = get_tree().get_nodes_in_group("units")
	var friendly = []
	for u in units:
		# Skip the current character unit
		if u.army == 0:
			friendly.append(u)
	return friendly
	
	
func get_enemy_units():
	var units = get_tree().get_nodes_in_group("units")
	var enemy = []
	for u in units:
		# Skip the current character unit
		if u.army != 0:
			enemy.append(u)
	return enemy
	
	
	
	
func get_unit_and_location():
	var units = get_tree().get_nodes_in_group("units")
	var cells = []
	for u in units:
		# Skip the current character unit
		#if u == char:
			#continue
		var global = u.global_position
		var cell = Tilemap.local_to_map(Tilemap.to_local(global))
		cells.append([u,cell])
	return cells
	
	
	
func doEnemyTurns():
	print("starting enemy turns")
	var enemies = get_enemy_units()
	for enemy in enemies:
		var mvt = enemy.unitClass.movement
		var attRange = enemy.inventory[0].weaponRange
		var pos = Tilemap.local_to_map(Tilemap.to_local(enemy.global_position))
		rebuild_pathfinding_attack(Tilemap)
		var reachable = get_reachable_cells(pos, mvt)
		print(reachable)
		var allU = get_unit_and_location()
		var charToHit = []
		for u in allU:
			print(u[1])
			if u[0].army == 0 and u[1] in reachable:
				charToHit.append(u[0])
				
		if charToHit.is_empty():
			print("1 enemy didn't hit")
		else:
			var charHit = charToHit.pick_random()
			var dmg = enemy.calcDamage()
			charHit.takeDamage(dmg)
			print("Char took " , dmg , " damage")
				
		
			
		
		
