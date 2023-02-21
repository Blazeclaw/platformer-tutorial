extends Area2D
class_name BreakBlock

export var deathParticle: PackedScene

func _on_Breakblock_body_entered(player: Node) -> void:
	if player is Player and player.powered_up:
		SoundPlayer.play_sound(SoundPlayer.EXPLOSION)

		# Create explosion
		var particle = deathParticle.instance()
		get_tree().current_scene.add_child(particle)

		particle.global_position = global_position
		particle.global_rotation = global_rotation
		
		particle.emitting = true
		particle.one_shot = true

		queue_free()
