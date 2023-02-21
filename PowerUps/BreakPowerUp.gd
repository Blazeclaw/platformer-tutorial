extends Area2D
class_name PowerUp

func _on_PowerUp_body_entered(player: Node) -> void:
	print("powerup collision with", player)
	# godot told us we collided with body, whatever that is

	# What is node? Is it a player?
	if player is Player:
		# power up the player
		player.power_up()
		queue_free()
	#if Player.powered_up player get_node ("PlayerGreenSkin")
