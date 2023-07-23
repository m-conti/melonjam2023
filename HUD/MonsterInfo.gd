extends PanelContainer

var info_instance: PackedScene = load("res://HUD/TopRightInfo.tscn")
var infos

var monster_desc = {
	"Clampbeetle": "Clampbeetle : A land creature",
	"Firewasp": "Firewasp : A flying creature",
	"Flying Locust": "Flying Locust : A flying creature",
	"Voidbutterfly": "Voidbutterfly : A flying creature",
	"Firebug": "Firebug : A land creature",
	"Leafbug": "Leafbug : A flying creature",
	"Magma Crab": "Magma Crab : A land creature",
	"Scorpion": "Scorpion : A land creature",
}


func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	infos = info_instance.instantiate()
	infos.get_node("TopRightInfo/MarginContainer/Label").text = get_info()
	
	add_child(infos)

func _on_mouse_exited():
	if is_instance_valid(infos):
		infos.queue_free()

func _exit_tree():
	_on_mouse_exited()

func get_info() -> String:
	return monster_desc[editor_description]
