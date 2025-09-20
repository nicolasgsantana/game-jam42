extends Node2D

@onready var main = get_node("/root/Main")

var enemy_type_1_green_scene := preload("res://scenes/enemy_type_1_green.tscn")
var spawn_points := []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i) # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	var spawn = spawn_points[randi() % spawn_points.size()]
	var enemy_type_1_green = enemy_type_1_green_scene.instantiate()
	enemy_type_1_green.position = spawn.position
	main.add_child(enemy_type_1_green)
