extends Node

const HURT = preload("res://sounds/hurt.wav")
const JUMP = preload("res://sounds/jump.wav")
const POWER_UP = preload("res://sounds/power_up.wav")
const EXPLOSION = preload("res://sounds/explosion.wav")
onready var audioPlayers = $AudioPlayer

func play_sound(sound):
	for audioPlayer in audioPlayers.get_children():
		if audioPlayer is AudioStreamPlayer:
			if not audioPlayer.playing:
				audioPlayer.stream = sound
				audioPlayer.play()
				break
