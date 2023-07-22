extends Node2D
class_name Game

var Map = load("res://map.tscn")

var displayed_map_index:
	get: return $MapsContainer.get_children().find(func (m: Node2D): return m.visible)

var displayed_map: Map:
	get: return get_map_by_index(displayed_map_index)

func get_map_by_index(index: int) -> Map:
	return $MapsContainer.get_child((index + $MapsContainer.get_child_count()) % $MapsContainer.get_child_count())

func _input(event):
	if event.is_action_pressed("game_next_map"):
		var current_index = displayed_map_index
		displayed_map.set_visibility(false)
		get_map_by_index(current_index + 1).set_visibility(true)
	elif event.is_action_pressed("game_previous_map"):
		var current_index = displayed_map_index
		displayed_map.set_visibility(false)
		get_map_by_index(current_index - 1).set_visibility(true)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start_game():
	if multiplayer.is_server(): set_maps()


func set_maps():
	for player_id in NetworkState.get_player_keys():
		var map = Map.instantiate()
		map.name = str(player_id)
		print("Server set_map: %d" % player_id)
		$MapsContainer.add_child(map)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func remove_pages():
	$pages.remove_child($pages/lobby)
