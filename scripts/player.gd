extends CharacterBody2D


const SPEED = 13000.0
const JUMP_VELOCITY = -300.

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var jumped_fall = false

func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get Direction
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true 	
	
	# Play Animations
	if animated_sprite_2d.animation != "ded":
		if is_on_floor():
			jumped_fall = false
			if direction == 0:
				animated_sprite_2d.play("idle")
			else:
				animated_sprite_2d.play("walking")
		else:
			if jumped_fall:
				animated_sprite_2d.play("falling")
			else:
				animated_sprite_2d.play("falling")
	

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		jumped_fall = true
		velocity.y = JUMP_VELOCITY 
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	move_and_slide()
