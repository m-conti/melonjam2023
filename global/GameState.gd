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
signal end
signal map_changed(Map)

var game: Game:
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

func check_end():
	var maps = game.get_node("MapsContainer").get_children()
	var deads = 0
	for map in maps:
		if map.is_dead: deads += 1
	if deads >= maps.size() - 1:
		end_game()

func end_game():
	if not multiplayer.is_server(): return
	print("END GAME")
	game.get_node("SyncPages").add_child(load("res://menu/EndOfGame.tscn").instantiate())


func disconnect_game():
	if is_game_strated():
		self.stop.emit()
	self.status = EGameStatus.DISCONNECTED
