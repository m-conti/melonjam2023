extends CanvasLayer



func _ready():
	if is_multiplayer_authority():
		$Shop/BoxContainer/Towers.show()
	$Shop/BoxContainer/Boost.show()
