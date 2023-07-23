extends ButtonShop
class_name DestroyButton

var is_active: bool = false

func __on_pressed():
	is_active = true

var mouse_pos

func _input(event):
	queue_redraw()
	if not is_active: return
	if event is InputEventMouseMotion:
		mouse_pos = event.position
	else: mouse_pos = null
	if not event is InputEventMouseButton: return
	if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var pos: Vector2i = map.tilemap.local_to_map(event.position / map.tilemap.scale)
		map.destoy_at_pos.rpc_id(map.get_multiplayer_authority(), pos)
		buy()
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		is_active = false

func _draw():
	if is_active and mouse_pos != null:
		draw_circle(mouse_pos - self.global_position, 10, Color.CRIMSON)
