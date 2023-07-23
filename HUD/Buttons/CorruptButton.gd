extends ButtonShop
class_name CorruptButton

@export var value: int = 5

func __on_pressed():
	PlayerState.add_corrupted.rpc_id(map.get_multiplayer_authority(), value)
	buy()
