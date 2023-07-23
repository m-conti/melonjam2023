extends Node2D
class_name Spawner

@export var cooldown: float = 0.2 # in second

func _enter_tree():
	set_multiplayer_authority(get_parent().get_multiplayer_authority())

func spawn():
	if len(GameState.game.mobs_to_spawn) <= 0:
		return
	
	var enemy = GameState.game.mobs_to_spawn.keys().pick_random()
	GameState.game.mobs_to_spawn[enemy] -= 1
	if GameState.game.mobs_to_spawn[enemy] <= 0:
		GameState.game.mobs_to_spawn.erase(enemy)
	
	var new_enemy: Enemy = load(enemy).instantiate()
	var map: Map = get_parent().get_parent()
	new_enemy.init(NetworkState.get_player_number_by_map(map), map.tilemap.local_to_map(position / map.tilemap.scale))

	get_parent().add_child(new_enemy, true)
	new_enemy.position = position


func place_on_map(pos: Vector2i):
	var timer: Timer = get_node("Timer")
	timer.wait_time = cooldown
	timer.timeout.connect(spawn)
