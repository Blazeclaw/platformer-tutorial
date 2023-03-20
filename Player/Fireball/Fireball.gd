extends Area2D
class_name Fireball

export var deathParticle: PackedScene

var max_speed: int = 40
var acceleration: int = 3
var direction: Vector2
var velocity := Vector2.ZERO

func _ready() -> void:
	set_process(true)
	SoundPlayer.play_sound(SoundPlayer.FIREBALL)

func _process(delta):
	velocity.x = move_toward(velocity.x, max_speed, acceleration * delta)
	position.x += direction.x * velocity.x
	# if timer = 3 scale_size = 1
	# if fireball.queue_free() timer = false
	
func _on_Fireball_body_entered(body: Node) -> void:
	if body is WalkingEnemy or body.is_in_group("enemies"):
		body.queue_free()

	die()

func die() -> void:
	var particle = deathParticle.instance()
	get_tree().current_scene.add_child(particle)
	SoundPlayer.play_sound(SoundPlayer.EXPLOSION)

	particle.global_position = global_position
	particle.global_rotation = global_rotation

	particle.emitting = true
	particle.one_shot = true

	queue_free()



func _on_Fireball_area_entered(area: Area2D) -> void:
	print("hit area ", area, area.get_owner(), area.get_parent())

	die()
	
