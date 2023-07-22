extends Node2D
class_name Map


@export var width: int = 20
@export var height: int = 20
@onready var tilemap: TileMap = $TileMap

var player_id: int

var grid: Array = []

func _init_grid():
	for x in width:
		grid.append([])
		for y in height:
			grid[x].append(null)

func _enter_tree():
	print("enter_tree")
	set_multiplayer_authority(self.name.to_int())

func _ready():
	print("ready")
	set_visibility(is_multiplayer_authority())
	if not is_multiplayer_authority(): return
	add_at_pos(load("res://Entities/Spawner.tscn"), Vector2i(3, 3))


func _init():
	_init_grid()


func set_player(player_id):
	set_multiplayer_authority(player_id)
	self.player_id = player_id


func is_in_grid(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < width and pos.y >= 0 and pos.y < height

@rpc("any_peer", "call_local")
func add_at_pos_by_ressource(path: String, pos: Vector2i):
	add_at_pos(load(path), pos)

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
