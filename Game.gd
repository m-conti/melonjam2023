extends Node2D

var Map = load("res://map.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for player_id in NetworkState.get_player_keys():
		var map = Map.instantiate()
		map.set_player(player_id)
		if map.is_current_player_map: map.show()
		else: map.hide()
		add_child(map)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
