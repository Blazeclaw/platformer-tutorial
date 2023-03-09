extends Area2D

var max_speed: int = 40
var acceleration: int = 3
var direction: Vector2
var velocity := Vector2.ZERO

func _ready() -> void:
	set_process(true)


func _process(delta):
	velocity.x = move_toward(velocity.x, max_speed, acceleration * delta)
	position.x += direction.x * velocity.x


func _on_Fireball_body_entered(body: Node) -> void:
	print("fireball hit ", body, body.get_groups())
	
	if body is WalkingEnemy:
		body.queue_free()

	queue_free()
