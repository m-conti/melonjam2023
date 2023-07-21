extends Node

enum EGameState {
	WAITING,
	READY,
	STARTED,
	DONE,
	DISCONNECTED
}

var state: EGameState = EGameState.WAITING


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func isGameStated():
	return state == EGameState.STARTED

func disconnectGame():
	self.state = EGameState.DISCONNECTED
