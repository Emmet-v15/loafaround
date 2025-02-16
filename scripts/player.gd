extends CharacterBody2D

const SPEED = 13000.0
const JUMP_VELOCITY = -300.

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var cutscene_player: AnimationPlayer = $"../AnimationPlayer"

#step 0: stop player movement until the cutscene is finished
var can_move = false

func _ready():

	var cutscene_name = &"cutscene"
	cutscene_player.play(cutscene_name) # Play the cutscene

	# step 1: get the length of the cutscene
	var cutscene_length = cutscene_player.get(cutscene_name).length

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
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jumped_fall = true
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY
			var particles = load("res://scenes/particles.tscn").instantiate()
			particles.global_position = global_position
			particles.emitting = true
			get_tree().root.add_child(particles)

	# Apply movement
	if direction:
		velocity.x = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	move_and_slide()
