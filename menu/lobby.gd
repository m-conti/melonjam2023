extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_environment("USERNAME"):
		$Connect/Name.text = OS.get_environment("USERNAME")
	else:
		var desktop_path = OS.get_system_dir(0).replace("\\", "/").split("/")
		$Connect/Name.text = desktop_path[desktop_path.size() - 2]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
