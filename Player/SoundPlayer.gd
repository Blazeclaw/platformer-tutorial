extends Node

const HURT = preload("res://Player/hurt.wav")
const JUMP = preload("res://Player/jump.wav")
const POWER_UP = preload("res://Player/power_up.wav")

onready var audioPlayers = $AudioPlayer

func play_sound(sound):
	for audioPlayer in audioPlayers.get_children():
		if audioPlayer is AudioStreamPlayer:
			if not audioPlayer.playing:
				audioPlayer.stream = sound
				audioPlayer.play()
				break
