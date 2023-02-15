extends Area2D

onready var animatedSprite := $AnimatedSprite

var active = true 

func _on_Checkpoint_body_entered(body: Node) -> void:
	if not body is Player:
		return
		  
	if not active:
		return
		
	animatedSprite.play("Checked")
	active = false
	GameState.lastCheckpointPosition = global_position
