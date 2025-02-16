extends Camera2D
@onready var player: CharacterBody2D = $"../Player"


var real_position

func _ready():
	real_position = Vector2(position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Smoothly follow the player
	real_position = lerp(real_position, player.position, 5.0 * delta)
	position = real_position
	
	# Clamp position to 15px down
	position.y = min(position.y, 150)
