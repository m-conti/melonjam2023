extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	NetworkState.connection_failed.connect(self._on_connection_failed)
	NetworkState.connection_succeeded.connect(self._on_connection_success)
	NetworkState.player_list_changed.connect(self.refresh_lobby)
	NetworkState.error.connect(self._on_network_error)
	if OS.has_environment("USERNAME"):
		$Connect/Name.text = OS.get_environment("USERNAME")
	else:
		var desktop_path = OS.get_system_dir(0).replace("\\", "/").split("/")
		$Connect/Name.text = desktop_path[desktop_path.size() - 2]


func _on_host_pressed():
	var player_name = $Connect/Name.text
	if player_name == "":
		$Connect/ErrorLabel.text = "Invalid name!"
		return

	$Connect.hide()
	$Players.show()
	$Connect/ErrorLabel.text = ""

	NetworkState.host_game(player_name)

func _on_join_pressed():
	var player_name = $Connect/Name.text
	if player_name == "":
		$Connect/ErrorLabel.text = "Invalid name!"
		return
	var ip = $Connect/IPAddress.text
	if not ip.is_valid_ip_address():
		$Connect/ErrorLabel.text = "Invalid IP address!"
		return
	$Connect/ErrorLabel.text = ""
	$Connect/Host.disabled = true
	$Connect/Join.disabled = true
	NetworkState.join_game(ip, player_name)

func _on_connection_success():
	$Connect.hide()
	$Players.show()

func _on_start_pressed():
	GameState.start_game.rpc()

func _on_connection_failed():
	$Connect/Host.disabled = false
	$Connect/Join.disabled = false
	$Connect/ErrorLabel.set_text("Connection failed.")

func _on_network_error(errtxt):
	$ErrorDialog.dialog_text = errtxt
	$ErrorDialog.popup_centered()
	$Connect/Host.disabled = false
	$Connect/Join.disabled = false

func refresh_lobby():
	var players = NetworkState.players
	var keys = players.keys()
	keys.sort()
	$Players/List.clear()
	for p in keys:
		if NetworkState.is_current_player_id(p):
			$Players/List.add_item(players[p] + " (You)")
		else:
			$Players/List.add_item(players[p])
	$Players/Start.disabled = not multiplayer.is_server()
