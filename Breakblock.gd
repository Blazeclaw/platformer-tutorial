extends Area2D
class_name BreakBlock

func _on_Breakblock_body_entered(player: Node) -> void:
	print("breakblock collsion with ", player)
	if player is Player and player.powered_up:
		queue_free()
