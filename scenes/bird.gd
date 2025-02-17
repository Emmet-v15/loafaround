extends Area2D

func _on_body_entered(_body: Node2D) -> void:
	GameManager.has_baguette = true
	get_parent().get_parent().get_node("AnimationPlayer").play("end")
	print("baguette")
