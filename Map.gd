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

func _ready():
	set_multiplayer_authority(self.name.to_int())
	print("""Scene:
	player_id: %s
	self_id: %d
	""" % [ self.name, multiplayer.get_unique_id() ])
	print(is_multiplayer_authority())
	if is_multiplayer_authority(): show()
	else: hide()
	
	var spawner: Spawner = load("res://Entities/Spawner.tscn").instantiate()
	add_at_pos(spawner, Vector2i(3, 3))

func _init():
	_init_grid()


func set_player(player_id):
	set_multiplayer_authority(player_id)
	self.player_id = player_id


func is_in_grid(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < width and pos.y >= 0 and pos.y < height


func add_at_pos(object: Node2D, pos: Vector2i):
	if not (is_in_grid(pos) and grid[pos.x][pos.y] == null):
		return
	
	grid[pos.x][pos.y] = object
	
	if object.get_parent() == null:
		add_child(object)
	else:
		object.reparent(self)
	
	object.position = tilemap.map_to_local(pos)
