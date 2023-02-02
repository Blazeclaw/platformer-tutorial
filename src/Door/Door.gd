extends Area2D

export(String, FILE, "*.tscn") var target_level_path = ""

func _on_Door_body_entered(body: Node) -> void:
	if not body is Player: 
		return
	if target_level_path.empty(): 
		return
	if get_tree().change_scene(target_level_path) != OK:
		print("Scene '{0}' could not be loaded.".format([target_level_path]))
		return
