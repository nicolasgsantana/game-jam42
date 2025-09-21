extends Node2D

signal defeated

var easy_enemies: Array[PackedScene] = [
	preload("res://scenes/enemy_type_easy_green.tscn"),
	preload("res://scenes/enemy_type_easy_red.tscn"),
	preload("res://scenes/enemy_type_easy_yellow.tscn")
]

@onready var spawn_points: Array[Node] = $"Spawn Points".get_children()
@onready var enemy_node: Node = $Spawns
@onready var sfx_mounilette = $sfx_mounilette

var shots_counter: int = 0
var callables: Array[Callable] = [
	shoot_full_row,
	shoot_delayed,
	shoot_top_down,
	shoot_upper,
	shoot_lower,
	shoot_middle
]

func start_boss():
	show()
	$LifeTime.start()
	$CoolDown.start()

func shoot_full_row() -> void:
	shoot_upper()
	shoot_middle()
	shoot_lower()
 

func shoot_delayed() -> void:
	$MiniCoolDown.start()


func shoot_top_down() -> void:
	shoot_upper()
	shoot_lower()


func shoot_upper() -> void:
	var enemy = easy_enemies[randi() % easy_enemies.size()].instantiate()
	enemy.position = spawn_points[0].position
	enemy_node.add_child(enemy)


func shoot_middle() -> void:
	var enemy = easy_enemies[randi() % easy_enemies.size()].instantiate()
	enemy.position = spawn_points[1].position
	enemy_node.add_child(enemy)


func shoot_lower() -> void:
	var enemy = easy_enemies[randi() % easy_enemies.size()].instantiate()
	enemy.position = spawn_points[2].position
	enemy_node.add_child(enemy)


func _on_cool_down_timeout() -> void:
	callables[randi() % callables.size()].call()


func _on_mini_cool_down_timeout() -> void:
	if shots_counter == 0:
		shots_counter += 1
		shoot_upper()
		$MiniCoolDown.start()
	elif shots_counter == 1:
		shots_counter += 1
		shoot_middle()
		$MiniCoolDown.start()
	elif shots_counter == 2:
		shots_counter += 1
		shoot_lower()
		$MiniCoolDown.start()
	else:
		shots_counter = 0
		$MiniCoolDown.stop()


# Sua função de timeout do LifeTime
func _on_life_time_timeout() -> void:
	# Chama a função de sequência de morte de forma segura, no próximo frame.
	call_deferred("_start_death_sequence")

# Sua nova função para lidar com a morte do boss
func _start_death_sequence() -> void:
	# Verificação de segurança para garantir que o nó ainda está na árvore
	if not is_inside_tree():
		return
		
	$CoolDown.stop()
	
	# Aguarda 0.5 segundos para a animação de morte
	await get_tree().create_timer(0.5).timeout
	$AnimatedSprite2D.play("death")
	
	for enemy in enemy_node.get_children():
		enemy.die()
	sfx_mounilette.play()
	await get_tree().create_timer(3.0).timeout
	defeated.emit()
	queue_free()
