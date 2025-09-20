extends Node

@export var score_label: Label

var player_score: int = 0
var combat_area: Area2D

func _ready():
	combat_area = find_child("CombatArea", true, false)


func get_enemies_in_combat_area() -> Array:
	var enemies = []
	var bodies_in_area = combat_area.get_overlapping_bodies()
	for body in bodies_in_area:
		if body.is_in_group("enemies") and not body.is_dead:
			enemies.append(body)
	return enemies


func kill_enemy(enemy: Node):
	enemy.die()
	await get_tree().process_frame
	if enemy.get("is_dead") == true:
		add_score(1)


func add_score(points: int):
	player_score += points
	score_label.text = "Score: " + str(player_score)
