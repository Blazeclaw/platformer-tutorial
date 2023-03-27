extends Node2D
class_name Blackhole

onready var particleVacuum: Particles2D = $ParticleVacuum
onready var particleBall: Particles2D = $ParticleBall

func _ready() -> void:
	set_emitting(false)

func set_emitting(value: bool):
	particleBall.emitting = value
	particleVacuum.emitting = value
