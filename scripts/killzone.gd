extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	Engine.time_scale = 0.5
	for child in body.get_children():
		if child is AnimatedSprite2D:
			child.play("ded")
			child.queue_redraw()
		if child is CollisionShape2D:
			child.queue_free()

	body.velocity.y = -170
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale = 1
