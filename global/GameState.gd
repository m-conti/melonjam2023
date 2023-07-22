extends Node

enum EGameStatus {
	WAITING,
	READY,
	STARTED,
	DONE,
	DISCONNECTED
}

var status: EGameStatus = EGameStatus.WAITING

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func is_game_strated():
	return self.status == EGameStatus.STARTED

@rpc("authority", "call_local")
func start_game():
	self.status = EGameStatus.STARTED
	get_tree().change_scene_to_file("res://game.tscn")

func disconnect_game():
	self.status = EGameStatus.DISCONNECTED
