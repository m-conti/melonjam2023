extends Node

var gold: int = 0
var corruption: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.start.connect(_reset_state)

func _reset_state():
	gold = 0
	corruption = 0
