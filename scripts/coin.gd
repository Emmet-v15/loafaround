extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var texture: Texture2D;
@export var pickup_sound: AudioStreamWAV;


func _on_body_entered(_body: Node2D) -> void:
	GameManager.add_coin()
	animation_player.play("pickup")
