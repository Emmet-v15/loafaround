extends Node

var cutscene_played = true
var has_baguette = false
var has_food = {}

signal points_updated(new_point_count: int)
var points: int = 0:
	set(value):
		points = value
		points_updated.emit(points)

func add_point() -> void:
	points += 1
