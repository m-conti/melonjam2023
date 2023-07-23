extends Control

var PlayerLine: PackedScene = load("res://menu/EndOfGamePlayer.tscn")

func _enter_tree():
	set_multiplayer_authority(1)

# Called when the node enters the scene tree for the first time.
func _ready():
	if multiplayer.is_server():
		$CenterContainer/Players/CenterContainer/Container.add_child(PlayerLine.instantiate(), true)
		$CenterContainer/Players/Button.pressed.connect(_on_retry)
		$CenterContainer/Players/Button.show()
	deploy_player_info()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func deploy_player_info():
	var info = {
		"name": NetworkState.player_name,
		"corruption": PlayerState.corruption,
		"gold": PlayerState.gold,
		"dead": PlayerState.isDead,
	}
	add_player_info.rpc_id(get_multiplayer_authority(), info)


@rpc("any_peer", "call_local")
func add_player_info(info: Dictionary):
	var new_player_line: EndOfGamePlayer = PlayerLine.instantiate()
	new_player_line.set_data(info)
	print(info)
	print(new_player_line.get_multiplayer_authority())
	$CenterContainer/Players/CenterContainer/Container.add_child(new_player_line, true)

func _on_retry():
	$ErrorDialog.dialog_text = "The game is too corrupted...\ntry to relauch it.\nmaybe reinstall the game or your computer."
	$ErrorDialog.popup_centered()
