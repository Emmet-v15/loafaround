extends CharacterBody2D

const SPEED = 13000.0
const JUMP_VELOCITY = -300.

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var cutscene_player: AnimationPlayer = $"../AnimationPlayer"
# Disable movement at start
var can_move = false
func _ready():
	if !GameManager.cutscene_played:
		cutscene_player.play(&"cutscene")
		await get_tree().create_timer(19.0).timeout  # Wait 16 seconds
		GameManager.cutscene_played = true
	can_move = true  # Enable movement

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
	if Input.is_action_pressed("jump") and is_on_floor():
		jumped_fall = true
		velocity.y = JUMP_VELOCITY 
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	move_and_slide()
