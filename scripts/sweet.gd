extends Node2D

@onready var animation_player: AnimationPlayer = $"./AnimationPlayer"
@onready var sound_player: AudioStreamPlayer2D = $"./AudioStreamPlayer2D"

@export var sound_effect: AudioStream

func _ready():
	sound_player.stream = sound_effect
	
func _on_body_entered(_body: Node2D) -> void:
	GameManager.add_point()
	animation_player.play("pickup")
