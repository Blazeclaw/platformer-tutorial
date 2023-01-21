extends Node

const HURT = preload("res://src/Player/hurt.wav")
const JUMP = preload("res://src/Player/jump.wav")

onready var audioPlayers = $AudioPlayer

func play_sound(sound):
	for audioPlayer in audioPlayers.get_children():
		if audioPlayer is AudioStreamPlayer:
			if not audioPlayer.playing:
				audioPlayer.stream = sound
				audioPlayer.play()
				break
