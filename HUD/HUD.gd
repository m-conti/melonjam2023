extends CanvasLayer



func _ready():
	$TopLeftContainer/MapDetail/Name.text = "map of " + NetworkState.players[$"..".name.to_int()]
	if is_multiplayer_authority():
		$Shop/BoxContainer/Towers.show()
	$Shop/BoxContainer/Boost.show()
