extends CharacterBody2D

const SPEED = 13000.0
const JUMP_VELOCITY = -300.

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var cutscene_player: AnimationPlayer = $"../AnimationPlayer"
@onready var baguette: Sprite2D = $Node2D/Baguette
@onready var animation_player: AnimationPlayer = $Node2D/Baguette/AnimationPlayer

#step 0: stop player movement until the cutscene is finished
var can_move = false

var extra_jumps = 1
var _current_extra_jumps = 0
var _old_direction = false
var _lagged_position = Vector2()
var _velocity = Vector2()

func _ready():

	var cutscene_name = &"cutscene"
	cutscene_player.play(cutscene_name) # Play the cutscene

	# step 1: get the length of the cutscene
	var cutscene_length = cutscene_player.get_animation(cutscene_name).length

	# step 2: check the global variable to see if the cutscene has been played
	if !GameManager.cutscene_played:
		await get_tree().create_timer(cutscene_length).timeout # Wait for the cutscene to finish
		GameManager.cutscene_played = true # Set the global variable to true so we don't play the cutscene next time we load this code
	
	cutscene_player.seek(cutscene_length) # Skip the cutscene (seek means jump to a specific time in the animation)

	# step 3: allow player movement if the cutscene has been played or we are skipping the cutscene
	can_move = true

func _process(delta):
	if can_move:
		move(delta)  # Replace with your movement logic
		
func move(delta):
	var jumped_fall = false

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		_current_extra_jumps = extra_jumps

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

	if Input.is_action_pressed("attack"):
		animation_player.play("swing")
		baguette.get_parent().scale.x = -1 if animated_sprite_2d.flip_h else 1
	else:
		animation_player.stop()

	if _old_direction != animated_sprite_2d.flip_h:
		_old_direction = animated_sprite_2d.flip_h
		baguette.get_parent().scale.x = -1 if animated_sprite_2d.flip_h else 1
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jumped_fall = true
			velocity.y = JUMP_VELOCITY
		elif _current_extra_jumps > 0:
			_current_extra_jumps -= 1
			velocity.y = JUMP_VELOCITY
			var super_jump = load("res://scenes/super_jump.tscn").instantiate()
			super_jump.global_position = global_position
			get_tree().root.add_child(super_jump)
			super_jump.flip_h = animated_sprite_2d.flip_h
			await get_tree().create_timer(0.5).timeout
			super_jump.queue_free()

	# Apply movement
	if direction:
		velocity.x = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	_lagged_position = lerp(_lagged_position, baguette.global_position, 0.1)
	baguette.global_position = _lagged_position
	_velocity = lerp(_velocity, Vector2(0, 0), 0.9)
	baguette.global_position += _velocity * delta


	move_and_slide()
