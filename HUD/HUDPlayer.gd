extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.map_changed.connect(_on_map_change)
	GameState.start.connect(_on_start_game)
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_game():
	self.show()

func _on_map_change(map: Map):
	if map.is_multiplayer_authority():
		$Shop/BoxContainer/Towers.show()
	else:
		$Shop/BoxContainer/Towers.hide()
