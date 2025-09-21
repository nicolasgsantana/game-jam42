#game_manager.gd
extends Node

@export var score_label: Label
@onready var sfx_main = $"../sfx_main"
@export var boss_treshhold: int = 40

var player_score: int = 0
var combat_area: Area2D
@onready var timer = $Timer
var is_boss_called: bool = false

func _ready():
	combat_area = $"../CombatArea"
	sfx_main.play()

func get_enemies_in_combat_area() -> Array:
	var enemies = []
	var bodies_in_area = combat_area.get_overlapping_bodies()
	for body in bodies_in_area:
		if body.is_in_group("enemies") and not body.is_dead:
			enemies.append(body)
	return enemies


func add_score(points: int):
	player_score += points
	score_label.text = "Score: " + str(player_score)
	if player_score >= boss_treshhold and not is_boss_called:
		is_boss_called = true
		$"../EnemySpawnerBasic".stop_timer()
		await get_tree().create_timer(1).timeout
		$"../Moulinette".start_boss()


func _on_input_handler_buffer_changed(buffer: Array) -> void:
	var enemies: Array = get_enemies_in_combat_area()
	for enemy in enemies:
			if not enemy.is_dead:
				enemy.word_feedback(buffer)


func _on_input_handler_command_sent(command: Array, difficulty: int) -> void:
	var enemies: Array = get_enemies_in_combat_area()
	var player_input: String
	for c in command:
		player_input += char(c)
	for enemy in enemies:
			if not enemy.is_dead:
				if enemy.check_command(player_input):
					add_score(1)


func _on_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		$"../Life".lost_life()


func _on_moulinette_defeated() -> void:
	pass
