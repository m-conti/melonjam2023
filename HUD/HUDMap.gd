extends CanvasLayer



func _ready():
	$TopLeftContainer/MapDetail/Name.text = "map of " + NetworkState.players[$"..".name.to_int()]

