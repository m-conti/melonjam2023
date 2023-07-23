extends Node2D
class_name Game

var Map = load("res://map.tscn")

var mobs_to_spawn: Dictionary = {}
var wave_step: int = 0
var next_wave: Dictionary = {}

signal spawn_wave(next_wave: Dictionary)

var displayed_map_index:
	get:
		for i in $MapsContainer.get_child_count():
			if $MapsContainer.get_child(i).visible:
				return i
		return -1

var displayed_map: Map:
	get: return get_map_by_index(displayed_map_index)

var player_map: Map:
	get: return $MapsContainer.get_node(str(get_multiplayer_authority()))

func get_map_by_index(index: int) -> Map:
	return $MapsContainer.get_child((index + $MapsContainer.get_child_count()) % $MapsContainer.get_child_count())

func _input(event):
	if not GameState.is_game_strated(): return
	if event.is_action_pressed("game_next_map"):
		var maps = $MapsContainer.get_children()
		var current_index = displayed_map_index
		displayed_map.set_visibility(false)
		get_map_by_index(current_index + 1).set_visibility(true)
		GameState.map_changed.emit(displayed_map)
	elif event.is_action_pressed("game_previous_map"):
		var current_index = displayed_map_index
		displayed_map.set_visibility(false)
		get_map_by_index(current_index - 1).set_visibility(true)
		GameState.map_changed.emit(displayed_map)

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.start.connect(_on_start_game)


func _on_start_game():
	self.remove_pages()
	self.start_game()
	$CorruptionGain.timeout.connect(_gain_corruption)
	$CorruptionGain.start()
	if multiplayer.is_server():
		$WaveTimer.start()
		$WaveTimer.timeout.connect(func(): self.emit_spawn.rpc(server_create_wave()))
		self.emit_spawn.rpc(server_create_wave())


func server_create_wave() -> Dictionary:
	var this_next_wave: Dictionary = next_wave
	next_wave = {}
	
	var mobs: Array = []
	for mob in ["Clampbeetle", "Firebug", "Firewasp", "Flying Locust", "Leafbug", "Magma Crab", "Scorpion", "Voidbutterfly"]:
		mobs.append("res://Enemies/Enemies/" + mob + ".tscn")
	
	for i in range(int(1.2 * wave_step) + int(wave_step / 5)*10 + 5):
		var mob = mobs.pick_random()
		next_wave[mob] = next_wave.get(mob, 0) + 1
	
	wave_step += 1
	
	spawn_wave.emit(next_wave)
	return this_next_wave


@rpc("authority", "call_local")
func emit_spawn(wave: Dictionary):
	for enemy in wave:
		mobs_to_spawn[enemy] = mobs_to_spawn.get(enemy, 0) + wave[enemy]

func start_game():
	if multiplayer.is_server(): set_maps()

func _on_stop_game():
	$CorruptionGain.stop()
	pass

func set_maps():
	for player_id in NetworkState.get_player_keys():
		var map = Map.instantiate()
		map.name = str(player_id)
		print("Server set_map: %d" % player_id)
		$MapsContainer.add_child(map)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _gain_corruption():
	var mobs = get_tree().get_nodes_in_group("enemies")
	var corruption: int = 0
	for mob in mobs:
		if not mob.is_in_group("enemies_of_1"):
			corruption += mob.corruption
	PlayerState.add_corruption(corruption)

func remove_pages():
	$pages.remove_child($pages/lobby)
