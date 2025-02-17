extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sound_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var sound_effect: AudioStream

func _ready():
	if GameManager.has_food[name]:
		queue_free()
	sound_player.stream = sound_effect
	
func _on_body_entered(_body: Node2D) -> void:
	GameManager.add_point()
	GameManager.has_food[name] = true
	animation_player.play("pickup")

