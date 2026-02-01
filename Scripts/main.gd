extends Node2D

@onready var Tilemap: TileMapLayer = $TileMapLayer
@onready var highlight_map: TileMapLayer = $HighlightMap
@onready var char

var astar := AStar2D.new()

var start_cell

signal enemy_turn

#enum GameState {
	#BEGIN_TURN,
	#SELECTING,
	#CHOOSING,
	#MOVING,
	#ATTACKING,
	#ENEMY_TURN,
#}
#var current_state: GameState = GameState.BEGIN_TURN


func _ready() -> void:
	emit_signal("enemy_turn")
	highlight_map.visible = true
	highlight_map.modulate = Color(0.115, 0.69, 0.0, 0.38)
	rebuild_pathfinding(Tilemap)


func _process(delta):
	if globs.current_state == globs.GameState.MOVING:
		if globs.mvt_setup == true:
			start_cell = Tilemap.local_to_map(Tilemap.to_local(char.global_position))
			var reachable = get_reachable_cells(start_cell, char.unitClass.movement)
			highlight_reachable(reachable)
			globs.mvt_setup = false
			
	if globs.current_state == globs.GameState.ATTACKING:
		if globs.mvt_setup == true:
			rebuild_pathfinding_attack(Tilemap)
			start_cell = Tilemap.local_to_map(Tilemap.to_local(char.global_position))
			var reachable = get_reachable_cells(start_cell, char.inventory[0].weaponRange)
			highlight_reachable(reachable)
			globs.mvt_setup = false
			
	if globs.current_state == globs.GameState.ENEMY_TURN:
		if globs.eTurnSetup == true:
			globs.eTurnSetup = false 
			globs.mvt_setup == false
			print("Changed to Enemy Turn")
			globs.char_to_act = []
			
			doEnemyTurns()
			globs.current_state = globs.GameState.BEGIN_TURN
			
			
	if globs.current_state == globs.GameState.BEGIN_TURN:
		globs.char_to_act.append_array(get_friendly_units())
		print(globs.char_to_act)
		globs.current_state = globs.GameState.SELECTING
		
	
		
		
		
		
		
		
		
		
		
		
			
			
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if globs.current_state == globs.GameState.MOVING:
				
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
					$Camera2D2/PlayerMenu.visible = !$Camera2D2/PlayerMenu.visible
					# Move to final tile (for now: instant move)
					char.global_position = path[-1]
					rebuild_pathfinding(Tilemap)
					highlight_map.clear()
					globs.char_to_act.erase(char)
					globs.current_state = globs.GameState.SELECTING
					
					
			elif globs.current_state == globs.GameState.SELECTING:
				if len(globs.char_to_act) == 0:
					globs.current_state = globs.GameState.ENEMY_TURN
					doEnemyTurns()
					globs.current_state = globs.GameState.BEGIN_TURN
				
				var click_pos := get_global_mouse_position()
				var target_cell := Tilemap.local_to_map(Tilemap.to_local(click_pos))
				var units = get_unit_and_location()
				
				for u in units:
					if target_cell == u[1]:
						if u[0].army == 0 and u[0] in globs.char_to_act:
							char = u[0]
							globs.selectedPlayer = u[0]
							rebuild_pathfinding(Tilemap)
							globs.mvt_setup = true
							$Camera2D2/PlayerMenu.visible = !$Camera2D2/PlayerMenu.visible
							globs.current_state = globs.GameState.CHOOSING
						
			elif globs.current_state == globs.GameState.ATTACKING:
				
				
				
				
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
						globs.selectedEnemy = u[0]
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
					$Camera2D2/EnemyStatOverlay.setEnemyStats()
					$Camera2D2/EnemyStatOverlay.visible = !$Camera2D2/EnemyStatOverlay.visible
					#CODE MOVED TO ON ATTACK PRESSED
						
						
						
	if event is InputEventKey:
		if globs.current_state == globs.GameState.CHOOSING:
			pass
			#if event.keycode == KEY_A and event.pressed:
				#print("Changed to Attacking")
				#globs.current_state = globs.GameState.ATTACKING
			#if event.keycode == KEY_M and event.pressed:
				#print("Changed to Moving")
				#$Camera2D2/PlayerMenu.visible = !$Camera2D2/PlayerMenu.visible
				#globs.current_state = globs.GameState.MOVING
			#if event.keycode == KEY_E and event.pressed:
				#print("Changed to Enemy Turn")
				#globs.char_to_act = []
				#globs.mvt_setup == false
				#doEnemyTurns()
				#globs.current_state = globs.GameState.BEGIN_TURN

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
		highlight_map.set_cell(cell, 0, Vector2i(0, 0))
		
		
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
			print("1 enemy couldn't hit")
		else:
			var charHit = charToHit.pick_random()
			var dmg = enemy.calcDamage(charHit)
			var check = randi_range(1, 100)
			if enemy.calcHitrate(charHit) >= check:
				charHit.takeDamage(dmg)
				print("Char took " , dmg , " damage")
				
				enemy.animPos = enemy.global_position
				enemy.targetPos = charHit.global_position
				await enemy.attackAnim()
			else:
				print("1 enemy didn't hit")
		

func _on_attack_pressed() -> void:
	$Camera2D2/EnemyStatOverlay.visible = !$Camera2D2/EnemyStatOverlay.visible
	#$Camera2D2/PlayerMenu.visible = !$Camera2D2/PlayerMenu.visible
	print("attacked enemy")
	# DO ATTACK STUFF HERE __________________________________________________
	
	var check = randi_range(1, 100)
	print(char.calcHitrate(globs.selectedEnemy))
	print(check)
	if char.calcHitrate(globs.selectedEnemy) >= check:
		globs.selectedEnemy.takeDamage(char.calcDamage(globs.selectedEnemy))
		print("Enemy took " , char.calcDamage(globs.selectedEnemy) , " damage")
		char.animPos = char.global_position
		char.targetPos = globs.selectedEnemy.global_position
		await char.attackAnim()
		
		
		
		
	else:
		print("Character Missed")

	highlight_map.clear()
	globs.char_to_act.erase(char)
	globs.current_state = globs.GameState.SELECTING
						


func _on_attack_button_pressed() -> void:
	print("Changed to Attacking")
	$Camera2D2/PlayerMenu.visible = !$Camera2D2/PlayerMenu.visible
	globs.current_state = globs.GameState.ATTACKING
