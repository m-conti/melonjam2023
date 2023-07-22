extends CanvasLayer



func _ready():
	$TopLeftContainer/UserDetail/Name.text = "id: " + $"..".name
	if is_multiplayer_authority():
		$Shop/BoxContainer/Towers.show()
	$Shop/BoxContainer/Boost.show()
