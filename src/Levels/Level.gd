extends Node2D

const PlayerScene = preload("res://src/Player/Player.tscn")

onready var camera := $Camera2D
onready var player := $Player
onready var timer := $Timer

func _ready() -> void:
	VisualServer.set_default_clear_color(Color.lightblue)
	player.connect_camera(camera)

	if GameState.lastCheckpointPosition:
		player.position = GameState.lastCheckpointPosition

	Events.connect("player_died", self, "_on_player_died")

func _on_player_died():
	timer.start(1.0)
	yield(timer, "timeout")
	assert(get_tree().reload_current_scene() == OK)
