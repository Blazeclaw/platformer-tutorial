extends Node2D

enum{HOVER, FALL, LAND, RISE}

var state = HOVER
var velocity = Vector2.ZERO

onready var start_position = global_position
onready var timer := $Timer
onready var raycast := $RayCast2D
onready var animatedSprite := $AnimatedSprite
export(int) var fall_acceleration = 1000
export(int) var fall_speed = 3000
export(int) var rise_acceleration = 50
export(int) var rise_speed = 300
export(float) var delay_time = 0.75

func _physics_process(delta: float) -> void:
	match state:
		HOVER: hover_state()
		FALL: fall_state(delta)
		LAND: land_state()
		RISE: rise_state(delta)
	
func hover_state():
	state = FALL
	velocity = Vector2.ZERO
	
func fall_state(delta: float):
	animatedSprite.play("Falling")
	velocity.y = move_toward(velocity.y, fall_speed, fall_acceleration * delta)
	# position.y += move_toward(position.y, fall_speed * delta, delta) # fall_speed * delta

	position.y += velocity.y * delta
	if raycast.is_colliding():
		var collision_point = raycast.get_collision_point()
		position.y = collision_point.y
		state = LAND
		velocity = Vector2.ZERO
		timer.start(delay_time)

func land_state():
	if timer.time_left <= 0:
		state = RISE

func rise_state(delta: float):
	animatedSprite.play("Rising")
	velocity.y = move_toward(velocity.y, rise_speed * 10, rise_acceleration * delta)
	# position.y = move_toward(position.y, start_position.y, rise_speed * delta)
	position.y -= velocity.y * delta
	if position.y <= start_position.y:
		state = HOVER
