extends Node2D

@onready var Tilemap: TileMapLayer = $TileMapLayer
@onready var highlight_map: TileMapLayer = $HighlightMap
@onready var char = $Unit


var astar := AStar2D.new()
var movement := 3


func _ready() -> void:
	
	highlight_map.visible = true
	highlight_map.modulate = Color(0.115, 0.69, 0.0, 0.38)
	
	rebuild_pathfinding(Tilemap)
	
	var start_cell := Tilemap.local_to_map(Tilemap.to_local(char.global_position))
	var reachable := get_reachable_cells(start_cell, movement)
	highlight_reachable(reachable)
	
	print("A* nodes:", astar.get_point_count())

	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var click_pos := get_global_mouse_position()
			var target_cell := Tilemap.local_to_map(Tilemap.to_local(click_pos))
			var start_cell := Tilemap.local_to_map(Tilemap.to_local(char.global_position))

			if not target_cell in Tilemap.get_used_cells():
				return

			var path := find_path(Tilemap, start_cell, target_cell)

			# Path must exist and be within movement range
			if path.is_empty():
				return

			var steps := path.size() - 1
			if steps <= movement:
				# Move to final tile (for now: instant move)
				char.global_position = path[-1]
				start_cell = Tilemap.local_to_map(Tilemap.to_local(char.global_position))
				var reachable = get_reachable_cells(start_cell, movement)
				highlight_reachable(reachable)


func build_astar(tilemap: TileMapLayer) -> void:
	astar.clear()

	for cell in tilemap.get_used_cells():
		if cell in get_unit_cells():
			continue

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
		if steps <= max_movement:
			reachable.append(cell)

	return reachable
	
	
func highlight_reachable(reachable_cells: Array[Vector2i]) -> void:
	highlight_map.clear()  # Remove previous highlights

	for cell in reachable_cells:
		highlight_map.set_cell(cell, 1, Vector2i(0, 0))
		
		
#func get_unit_cells():
	#var units = find_children("Unit")
	#if units.has(char):
		## 2. Remove the instance from the array
		#units.erase(char)
		#print("Removed child from the array.")
	#
	#var cells = []
	#for u in units:
		#var global = u.global_position
		#var cell = Tilemap.local_to_map(Tilemap.to_local(global))
		#cells.append(cell)
	#return cells
	#
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
