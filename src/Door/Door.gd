extends Area2D

export(String, FILE, "*.tscn") var target_level_path = ""

var player: Player = null

func go_to_next_room() -> void:
	if target_level_path.empty(): 
		return

	Transitions.play_exit_transition()
	get_tree().paused = true

	yield(Transitions, "transition_completed")

	Transitions.play_enter_transition()
	get_tree().paused = false

	if get_tree().change_scene(target_level_path) != OK:
		print("Scene '{0}' could not be loaded.".format([target_level_path]))
		return

func _process(delta: float) -> void:
	if not player or not player.is_on_floor():
		return
		
	if Input.is_action_just_pressed("ui_accept"):
		go_to_next_room()

func _on_Door_body_entered(body: Node) -> void:
	if not body is Player: 
		return

	player = body

func _on_Door_body_exited(body: Node) -> void:
	if not body is Player: 
		return
	
	player = null
