extends Node2D


var enemy_type_1_green_scene: PackedScene = preload("res://scenes/enemy_type_1_green.tscn")
var spawn_points: Array = []

func _ready() -> void:
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)

func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	var spawn = spawn_points[randi() % spawn_points.size()]
	var enemy_type_1_green = enemy_type_1_green_scene.instantiate()
	enemy_type_1_green.position = spawn.position
	add_child(enemy_type_1_green)
