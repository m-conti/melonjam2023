extends Node

const DEFAULT_PORT = 10567
const MAX_PEERS = 4

var peer = null

var player_name = ""

var players = {}
var players_ready = []

signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal error(what)


func get_player_list():
	return players.values()

func get_player_keys():
	return players.keys()

func get_player_name():
	return player_name

func is_current_player_id(id: int):
	if not multiplayer: return true
	return multiplayer.get_unique_id() == id


# Callback from SceneTree.
func _player_connected(id):
	# Registration of a client beings here, tell the connected player that we are here.
	register_player.rpc_id(id, player_name)

# Callback from SceneTree.
func _player_disconnected(id):
	if GameState.is_game_strated(): # Game is in progress.
		if multiplayer.is_server():
			error.emit("Player " + players[id] + " disconnected")
	else:
		unregister_player(id)


# Callback from SceneTree, only for clients (not server).
func _connected_ok():
	players[multiplayer.get_unique_id()] = player_name
	player_list_changed.emit()
	# We just connected to a server
	connection_succeeded.emit()


# Lobby management functions.
@rpc("any_peer")
func register_player(new_player_name):
	var id = multiplayer.get_remote_sender_id()
	players[id] = new_player_name
	player_list_changed.emit()

func unregister_player(id):
	players.erase(id)
	player_list_changed.emit()

# Callback from SceneTree, only for clients (not server).
func _server_disconnected():
	error.emit("Server disconnected")
	GameState.disconnect_game()

# Callback from SceneTree, only for clients (not server).
func _connected_fail():
	connection_failed.emit()


func host_game(new_player_name):
	player_name = new_player_name
	peer = ENetMultiplayerPeer.new()
	peer.create_server(DEFAULT_PORT, MAX_PEERS)
	multiplayer.set_multiplayer_peer(peer)
	players[multiplayer.get_unique_id()] = player_name
	player_list_changed.emit()

func join_game(ip, new_player_name):
	player_name = new_player_name
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, DEFAULT_PORT)
	multiplayer.set_multiplayer_peer(peer)


func _ready():
	multiplayer.peer_connected.connect(self._player_connected)
	multiplayer.peer_disconnected.connect(self._player_disconnected)
	multiplayer.connected_to_server.connect(self._connected_ok)
	multiplayer.connection_failed.connect(self._connected_fail)
	multiplayer.server_disconnected.connect(self._server_disconnected)
