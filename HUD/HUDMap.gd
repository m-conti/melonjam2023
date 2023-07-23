extends CanvasLayer

func _ready():
	if is_multiplayer_authority():
		PlayerState.corrupted_changed.connect(_on_corrupted_changed)
		PlayerState.die.connect(_on_die)
	$TopLeftContainer/MapDetail/Name.text = str(NetworkState.get_player_number_by_map($"..")) + " map of " + NetworkState.players[$"..".name.to_int()]

func _on_corrupted_changed(value: int):
	$CorruptedBackground.modulate = 0xffffff00 + ((value * 0xff) / 100)

func _on_die():
	$CorruptedBackground.color = 0x000000ff
	$CorruptedBackground.modulate = 0xffffffff

