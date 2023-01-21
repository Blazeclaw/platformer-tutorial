extends Node2D

enum{HOVER, FALL, LAND, RISE}

var state = HOVER

onready var start_poistion = global_position
onready var timer := $Timer
onready var raycast := $RayCast2D

func _physics_process(_delta: float) -> void:
	match state:
		HOVER: pass
		FALL: pass
		LAND: pass
		RISE: pass
	
func hover_state():
	state = FALL
	
func fall_state():
	position.y += 10
	if raycast.is_colliding():
		var collision = raycast.get_collision_point()
		position.y = collision.y
		
