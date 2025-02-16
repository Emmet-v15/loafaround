extends Node

var cutscene_played = false
signal coins_updated(new_coin_count: int)
var coins: int = 0:
	set(value):
		coins = value
		coins_updated.emit(coins)

func add_coin() -> void:
	coins += 1
