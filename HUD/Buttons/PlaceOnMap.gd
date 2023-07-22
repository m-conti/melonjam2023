extends ButtonShop
class_name PlaceOnMap

@export var instance: PackedScene
@export var activable_remote = false
var ghost: Node2D = null


func _on_pressed():
	ghost = instance.instantiate()
	ghost.modulate = Color(Color.WHITE, 0.5)

	add_child(ghost)


func _process(delta_time):
	if ghost == null: return
	
	var mouse_pos: Vector2i = map.tilemap.local_to_map(get_viewport().get_mouse_position() / map.tilemap.scale)
	
	if not can_be_placed(mouse_pos):
		ghost.visible = false
		return
	
	ghost.visible = true
	ghost.global_position = map.tilemap.map_to_local(mouse_pos) * map.tilemap.scale
	queue_redraw()


func _input(event):
	if ghost == null: return
	if not (activable_remote or map.is_multiplayer_authority()): return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var pos: Vector2i = map.tilemap.local_to_map(event.position / map.tilemap.scale)
			
			if not can_be_placed(pos):
				return
			
			ghost.queue_free()
			ghost = null
			print("ADD TO BOARD " + str(map.get_multiplayer_authority()))
			map.add_at_pos_by_ressource.rpc_id(map.get_multiplayer_authority(), instance.resource_path, pos)
		
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			ghost.queue_free()
			ghost = null

		queue_redraw()


func can_be_placed(pos: Vector2i) -> bool:
	return false
