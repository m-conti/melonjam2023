extends Node2D
class_name Enemy

@export var armor: int = 0
@export var speed: int = 10 # px / s
@export var hp: int = 10

@export var corruption: int = 0
@export var gold: int = 0

@export var fly: bool = false

@onready var map: Map = get_parent().get_parent()

var shaders = [
	preload("res://Enemies/Shaders/Red.gdshader"),
	preload("res://Enemies/Shaders/Blue.gdshader")]

var target_case: Vector2i
var prev_case: Vector2i

signal damage(amount)

func _enter_tree():
	set_multiplayer_authority(get_parent().get_multiplayer_authority())
	add_to_group("enemies")
	add_to_group("enemies_of_" + str(NetworkState.get_player_number_by_map(get_parent().get_parent())))

func init(player_number: int, current_case: Vector2i):
	$HitBox.set_collision_layer_value(player_number, true)
	$HitBox.set_collision_mask_value(player_number, true)

	
	target_case = current_case
	prev_case = current_case


func _ready():
	var player_index = NetworkState.get_player_index_by_id(self.get_multiplayer_authority())
	$Sprite2D.material = ShaderMaterial.new()
	$Sprite2D.material.shader = shaders[player_index]
#	print("New Enemy", self)
#	print("base values:")
#	print("armor:",  armor)
#	print("speed:", speed)
#	print("hp:", hp)
#	print("Modified values:")
#	print("armor:",  armor)
#	print("speed:", speed)
#	print("hp:", hp)
	pass


func _on_damage(amount):
	hp -= amount
	if hp <= 0:
		$AnimationPlayer.play("Die" + get_direction())
		$AnimationPlayer.animation_finished.connect(func(x): queue_free())


func get_next_case() -> Vector2i:
	var neighbours = [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP]
	neighbours.shuffle()
	
	for neighbour in neighbours:
		var new_target = target_case + neighbour
		if map.is_in_grid(new_target) and map.grid[new_target.x][new_target.y] == null and new_target != prev_case:
			return new_target
	
	return prev_case


func get_direction() -> String:
	var angle: float = Vector2(target_case - prev_case).angle()
	
	if angle >= PI / 4 and angle <= 3*PI / 4:
		return "Down"
	elif angle >= 3*PI / 4 or angle <= -3*PI / 4:
		return "Left"
	elif angle <= -PI / 4 and angle >= -3*PI / 4:
		return "Up"
	else:
		return "Right"


func _process(delta_time):
	if hp <= 0:
		return
	
	var target_pos: Vector2 = map.tilemap.map_to_local(target_case) * map.tilemap.scale
	position = position.move_toward(target_pos, speed * delta_time)

	if target_pos.is_equal_approx(position):
		var new_target_case = get_next_case()
		prev_case = target_case
		target_case = new_target_case
		
		$AnimationPlayer.play(get_direction())
