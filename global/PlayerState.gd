extends Node

var player_number: int = 1

var gold: int = 500
var corruption: int = 0

signal corruption_changed(int)
signal gold_changed(int)

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.start.connect(_reset_state)

func _reset_state():
	gold = 500
	gold_changed.emit(gold)
	corruption = 0
	corruption_changed.emit(corruption)

func add_corruption(value: int):
	corruption += value
	if corruption < 0:
		corruption = 0
	corruption_changed.emit(corruption)

func add_gold(value: int):
	gold += value
	if gold < 0:
		gold = 0
	gold_changed.emit(gold)
