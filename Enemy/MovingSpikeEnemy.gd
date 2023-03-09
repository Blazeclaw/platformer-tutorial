tool
extends Path2D
class_name MovingSpikeEnemy

enum ANIMATION_TYPE{
	LOOP,
	BOUNCE
}

export(ANIMATION_TYPE) var animation_type setget set_animation_type
export(int) var speed setget set_speed

onready var animationPlayer := $AnimationPlayer

func set_animation_type(value):
	animation_type = value
	var anim_player := find_node("AnimationPlayer")
	if anim_player:play_updated_animation(anim_player)

func set_speed(value):
	speed = value
	var anim_player = find_node("AnimationPlayer")
	if anim_player: anim_player.playback_speed = speed

func _ready() -> void:
	play_updated_animation(animationPlayer)

func play_updated_animation(anim_player):
	match animation_type:
		ANIMATION_TYPE.LOOP: anim_player.play("MoveAlongPathLoop")
		ANIMATION_TYPE.BOUNCE: anim_player.play("MoveAlongPathBounce")
