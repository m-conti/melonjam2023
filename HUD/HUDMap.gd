extends CanvasLayer

func _ready():
	if is_multiplayer_authority():
		PlayerState.corrupted_changed.connect(_on_corrupted_changed)
	$TopLeftContainer/MapDetail/Name.text = str(NetworkState.get_player_number_by_map($"..")) + " map of " + NetworkState.players[$"..".name.to_int()]

func _on_corrupted_changed(value: int):
	$CorruptedBackground.modulate = 0xffffff00 + ((value * 0xff) / 100)
