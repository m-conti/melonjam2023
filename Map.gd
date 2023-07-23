extends Node2D
class_name Map


@onready var tilemap: TileMap = $TileMap
@onready var width: int = tilemap.get_used_rect().size.x
@onready var height: int = tilemap.get_used_rect().size.y

var player_id: int
var is_dead = false

var grid: Array = []
var nb_path_case: int

var rotation_clockwise: bool = false

var destroy_anim: PackedScene = load("res://Towers/DestroyAnimation.tscn")

func get_first_path() -> Vector2i:
	for x in width:
		for y in height:
			if grid[x][y] == 0:
				return Vector2i(x, y)
	return Vector2i.ZERO


func _init_grid():
	var path_cells = [
		Vector2i(11, 1),
		Vector2i(12, 1),
		Vector2i(13, 1),
		Vector2i(14, 1),
		Vector2i(11, 2),
		Vector2i(14, 2),
		Vector2i(11, 3),
		Vector2i(14, 3),
		Vector2i(11, 4),
		Vector2i(12, 4),
		Vector2i(13, 4),
		Vector2i(14, 4),
		Vector2i(6, 1),
		Vector2i(5, 2),
		Vector2i(7, 2),
		Vector2i(6, 3),
	]
	
	for x in width:
		grid.append([])
		for y in height:
			if tilemap.get_cell_atlas_coords(0, Vector2i(x, y)) in path_cells:
				grid[x].append(0)
			else:
				grid[x].append(null)
	
	var last_path: Vector2i = get_first_path()
	var new_path: Vector2i = last_path
	var neighbours = [Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT, Vector2i.UP]
	var finished: bool = false
	
	while not finished:
		finished = true
		grid[new_path.x][new_path.y] = grid[last_path.x][last_path.y] + 1
		
		var current_path: Vector2i
		for neighbour in neighbours:
			current_path = new_path + neighbour
			if not is_in_grid(current_path):
				continue
			
			if grid[current_path.x][current_path.y] == 0:
				finished = false
				break
		last_path = new_path
		new_path = current_path
	
	nb_path_case = grid[last_path.x][last_path.y]
	

func _enter_tree():
	print("enter_tree")
	set_multiplayer_authority(self.name.to_int())

func _ready():
	print("ready")
	print(tilemap.get_used_rect())
	_init_grid()
	set_visibility(is_multiplayer_authority())
	PlayerState.player_die.connect(_on_player_die)
	if not is_multiplayer_authority(): return
	add_at_pos(load("res://Entities/Spawner.tscn"), Vector2i(3, 3))


func set_player(player_id):
	set_multiplayer_authority(player_id)
	self.player_id = player_id


func is_in_grid(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < width and pos.y >= 0 and pos.y < height

@rpc("any_peer", "call_local")
func add_at_pos_by_ressource(path: String, pos: Vector2i):
	add_at_pos(load(path), pos)

@rpc("any_peer", "call_local")
func destoy_at_pos(pos: Vector2i):
	if not is_in_grid(pos): return
	
	var object = grid[pos.x][pos.y]
	
	var anim: Sprite2D = destroy_anim.instantiate()
	anim.get_node("Animation").animation_finished.connect(func(x): anim.queue_free())
	$SyncContainer.add_child(anim)
	anim.position = tilemap.map_to_local(pos) * tilemap.scale
	
	if not object is Tower: return
	
	object.queue_free()
	grid[pos.x][pos.y] = null

func add_at_pos(instance: PackedScene, pos: Vector2i):
	print("PROCESS ADD " + str(get_multiplayer_authority()))
	if not (is_in_grid(pos) and grid[pos.x][pos.y] == null):
		return

	var object = instance.instantiate()
	grid[pos.x][pos.y] = object

	$SyncContainer.add_child(object, true)

	for child in object.get_children():
		if child is Area2D:
			child.set_collision_layer_value(NetworkState.get_player_number_by_map(self), true)
			child.set_collision_mask_value(NetworkState.get_player_number_by_map(self), true)

	object.position = tilemap.map_to_local(pos) * tilemap.scale
	object.place_on_map(pos)

func set_visibility(value: bool):
	if value:
		show()
		$HUD.show()
	else:
		hide()
		$HUD.hide()

func _on_player_die(id: int):
	if get_multiplayer_authority() == id:
		$SyncContainer.queue_free()
		is_dead = true
		if multiplayer.is_server():
			GameState.check_end()
