extends CanvasLayer

@export var mob_info: PackedScene

@onready var mobs = {
	"Clampbeetle": [load("res://Enemies/Enemies/Clampbeetle.png"), 64, 64],
	"Firewasp": [load("res://Enemies/Enemies/Firewasp.png"), 96, 96],
	"Flying Locust": [load("res://Enemies/Enemies/Flying Locust.png"), 64, 64],
	"Voidbutterfly": [load("res://Enemies/Enemies/Voidbutterfly.png"), 64, 64],
	"Firebug": [load("res://Enemies/Enemies/Firebug.png"), 128, 64],
	"Leafbug": [load("res://Enemies/Enemies/Leafbug.png"), 64, 64],
	"Magma Crab": [load("res://Enemies/Enemies/Magma Crab.png"), 64, 64],
	"Scorpion": [load("res://Enemies/Enemies/Scorpion.png"), 64, 64]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.map_changed.connect(_on_map_change)
	GameState.start.connect(_on_start_game)
	GameState.game.spawn_wave.connect(_on_wave_changed)
	PlayerState.corruption_changed.connect(_on_corruption_changed)
	PlayerState.gold_changed.connect(_on_gold_changed)
	PlayerState.die.connect(_on_player_die)
	PlayerState.player_die.connect(_on_other_player_die)
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_game():
	self.show()

func _on_map_change(map: Map):
	if map.is_dead:
		$Shop.hide()
		return
	$Shop.show()
	if map.is_multiplayer_authority():
		$Shop/BoxContainer/Towers.show()
	else:
		$Shop/BoxContainer/Towers.hide()

func _on_gold_changed(value: int):
	$TopRightContainer/Container/PlayerData/Gold.text = "Gold : " + str(value)

func _on_corruption_changed(value: int):
	$TopRightContainer/Container/PlayerData/Corruption.text = "Corruption : " + str(value)

func _on_player_die():
	self.hide()

func _on_other_player_die(id: int):
	if id == GameState.game.displayed_map.get_multiplayer_authority():
		$Shop.hide()

func _on_wave_changed(new_wave: Dictionary):
	for child in $TopRightContainer/Container/NextWave.get_children():
		child.queue_free()
	
	for monster in new_wave:
		var new_mob_info = mob_info.instantiate()
		new_mob_info.get_node("MonsterInfo/MarginContainer/Label").text = str(new_wave[monster]) + " x"
		
		var monster_name: String = monster.right(-22).left(-5)
		var texture: AtlasTexture = AtlasTexture.new()
		texture.region = Rect2(0, 0, mobs[monster_name][1], mobs[monster_name][2])
		texture.atlas = mobs[monster_name][0]
		new_mob_info.get_node("MonsterInfo/TextureRect").texture = texture
		new_mob_info.get_node("MonsterInfo/TextureRect").expand_mode = 1
		new_mob_info.get_node("MonsterInfo/TextureRect").custom_minimum_size = Vector2.ONE * 64.
		
		$TopRightContainer/Container/NextWave.add_child(new_mob_info)
