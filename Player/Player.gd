extends KinematicBody2D
class_name Player

const FIREBALL_SCENE = preload("res://Fireball.tscn")

enum {MOVE, CLIMB}

export(Resource) var moveData = preload("res://Player/DefaultPlayerMovementData.tres") as PlayerMovementData

var velocity := Vector2.ZERO
var state := MOVE
var double_jump: int = 1
var buffered_jump: bool = false
var coyote_jump: bool = false
var powered_up: bool = false

onready var animatedSprite := $AnimatedSprite
onready var ladderCheck := $LadderCheck
onready var jumpBufferTimer := $JumpBufferTimer
onready var coyoteJumpTimer := $CoyoteJumpTimer
onready var remoteTransform2D := $RemoteTransform2D
onready var powerUpTimer := $PowerUpTimer
onready var projectileSpawnPosition := $ProjectileSpawnPosition

func _physics_process(delta: float) -> void:
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")

	match state:
		MOVE: move_state(input, delta)
		CLIMB: climb_state(input)

func move_state(input: Vector2, delta: float) -> void:
	if is_on_ladder() and Input.is_action_just_pressed("ui_up"):
		state = CLIMB
	
	apply_gravity(delta)
	
	if not horizontal_move(input):
		apply_friction(delta)
		animatedSprite.animation = "Idle"
	else:
		apply_acceleration(input.x, delta)
		animatedSprite.animation = "Run"
		global_transform.x.x = input.x
	
	if is_on_floor():
		reset_double_jump()
	else:
		animatedSprite.animation = "Jump"
	
	if can_jump():
		input_jump()
	else:
		input_jump_release()
		input_double_jump()
		buffer_jump()
		fast_fall(delta)
	
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		animatedSprite.animation = "Run"
		animatedSprite.frame = 1
		
	var just_left_ground = not is_on_floor() and was_on_floor
	if just_left_ground and velocity.y >= 0:
		coyote_jump = true
		coyoteJumpTimer.start()

	if Input.is_action_just_pressed("attack"):
		var fireball = FIREBALL_SCENE.instance()
		fireball.global_position = projectileSpawnPosition.global_position
		fireball.direction = global_transform.x
		get_tree().current_scene.add_child(fireball)
		
func climb_state(input: Vector2) -> void:
	if not is_on_ladder():
		state = MOVE

	if input.length() != 0:
		animatedSprite.animation = "Run"
	else:
		animatedSprite.animation = "Idle"

	velocity = input * moveData.CLIMB_SPEED
	velocity = move_and_slide(velocity, Vector2.UP)

func player_die() -> void:
	SoundPlayer.play_sound(SoundPlayer.HURT)
	queue_free()
	Events.emit_signal("player_died")

func connect_camera(camera) -> void:
	var camera_path = camera.get_path()
	remoteTransform2D.remote_path = camera_path

func input_jump_release() -> void:
	if Input.is_action_just_released("ui_up") and velocity.y < moveData.JUMP_RELEASE_FORCE:
		velocity.y = moveData.JUMP_RELEASE_FORCE

func input_double_jump() -> void:
	if Input.is_action_just_pressed("ui_up") and double_jump > 0:
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = moveData.JUMP_FORCE
		double_jump -= 1

func buffer_jump() -> void:
	if Input.is_action_just_pressed("ui_up") and double_jump > 0:
		velocity.y = moveData.JUMP_FORCE
		double_jump -= 1

func fast_fall(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		buffered_jump = true
		jumpBufferTimer.start()

	if velocity.y > 0:
		velocity.y += moveData.ADITIONAL_FALL_GRAVITY * delta

func can_jump() -> bool:
	return is_on_floor() or coyote_jump

func horizontal_move(input: Vector2) -> bool:
	return input.x != 0

func reset_double_jump() -> void:
	double_jump = moveData.DOUBLE_JUMP_COUNT

func input_jump() -> void:
	if Input.is_action_just_pressed("ui_up") or buffered_jump:
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = moveData.JUMP_FORCE
		buffered_jump = false

func is_on_ladder() -> bool:
	if not ladderCheck.is_colliding():
		return false

	var collider = ladderCheck.get_collider()
	if not collider is Ladder:
		return false

	return true

func apply_gravity(delta: float) -> void:
	velocity.y += moveData.GRAVITY * delta
	velocity.y = min(velocity.y, 300)

func apply_friction(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, moveData.FRICTION * delta)

func apply_acceleration(amount: float, delta: float) -> void:
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amount, moveData.ACCELERATION * delta)

func power_up() -> void:
	powered_up = true
	SoundPlayer.play_sound(SoundPlayer.POWER_UP)
	powerUpTimer.start()

func _on_JumpBufferTimer_timeout() -> void:
	buffered_jump = false

func _on_CoyoteJumpTimer_timeout() -> void:
	coyote_jump = false

func _on_PowerUpTimer_timeout() -> void:
	powered_up = false
