extends Node

var player_number: int = 1

var gold: int = 500
var corruption: int = 0
var corrupted: int = 0
var isDead: bool = false

const MAX_CORRUPTED = 100

signal corruption_changed(int)
signal gold_changed(int)
signal corrupted_changed(int)
signal die
signal player_die(int)

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.start.connect(_reset_state)

func _reset_state():
	gold = 500
	gold_changed.emit(gold)
	corruption = 0
	corruption_changed.emit(corruption)

func add_corruption(value: int):
	if isDead: return
	corruption += value
	if corruption < 0:
		corruption = 0
	corruption_changed.emit(corruption)

func add_gold(value: int):
	if isDead: return
	gold += value
	if gold < 0:
		gold = 0
	gold_changed.emit(gold)

@rpc("any_peer", "call_local")
func add_corrupted(value: int):
	if isDead: return
	corrupted += value
	corrupted_changed.emit(corrupted)
	if corrupted >= MAX_CORRUPTED:
		kill()

@rpc("any_peer", "call_local")
func player_kill():
	player_die.emit(multiplayer.get_remote_sender_id())

func kill():
	isDead = true
	player_kill.rpc()
	die.emit()

func has_enought_gold(value: int): return not isDead and value <= gold
func has_enought_corruption(value: int): return not isDead and value <= corruption

func remove_gold(value: int): add_gold(-value)
func remove_corruption(value: int): add_corruption(-value)
