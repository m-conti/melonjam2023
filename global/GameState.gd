extends Node

enum EGameStatus {
	WAITING,
	READY,
	STARTED,
	DONE,
	DISCONNECTED
}

var status: EGameStatus = EGameStatus.WAITING

signal start
signal stop
signal map_changed(Map)

var game:
	get: return get_tree().root.get_node("game")

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
	self.start.emit()

func disconnect_game():
	if is_game_strated():
		self.stop.emit()
	self.status = EGameStatus.DISCONNECTED
