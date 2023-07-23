extends CanvasLayer



func _ready():
	$TopLeftContainer/MapDetail/Name.text = str(NetworkState.get_player_number_by_map($"..")) + " map of " + NetworkState.players[$"..".name.to_int()]

