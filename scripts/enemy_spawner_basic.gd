# EnemySpawner.gd - Sistema de spawn com dificuldade progressiva
extends Node2D

# Array com todos os tipos de inimigos
var enemy_scenes: Array[PackedScene] = [
	preload("res://scenes/enemy_type_easy_green.tscn"),
	preload("res://scenes/enemy_type_easy_red.tscn"),
	preload("res://scenes/enemy_type_easy_yellow.tscn"),
	preload("res://scenes/enemy_type_medium_green.tscn"),
	preload("res://scenes/enemy_type_medium_red.tscn"),
	preload("res://scenes/enemy_type_medium_yellow.tscn"),
	preload("res://scenes/enemy_type_hard_green.tscn"),
	preload("res://scenes/enemy_type_hard_red.tscn"),
	preload("res://scenes/enemy_type_hard_yellow.tscn")
]

# Nomes dos inimigos para debug
var enemy_names: Array[String] = [
	"EasyGreen", "EasyRed", "EasyYellow",
	"MediumGreen", "MediumRed", "MediumYellow", 
	"HardGreen", "HardRed", "HardYellow"
]

var spawn_points: Array = []

# CONFIGURAÇÕES DE DIFICULDADE PROGRESSIVA
@export_group("Dificuldade Progressiva")
@export var easy_phase_duration: float = 20.0      # Primeiros 20s só easy
@export var medium_phase_duration: float = 40.0    # 20s-60s easy+medium  
# Depois de 60s = todos os tipos

# CONFIGURAÇÕES DE VELOCIDADE DO TIMER
@export_group("Velocidade do Spawn")
@export var initial_spawn_time: float = 1.5       # Timer inicial (mais lento)
@export var minimum_spawn_time: float = 1      # Timer mínimo (mais rápido)
@export var speed_increase_interval: float = 8.0 # A cada 10s diminui o timer

# Variáveis de controle
var game_time: float = 0.0
var timer_node: Timer

func _ready() -> void:
	# Coleta pontos de spawn
	for child in get_children():
		if child is Marker2D:
			spawn_points.append(child)
	
	# Configura o timer
	timer_node = get_node("Timer")
	if timer_node:
		timer_node.wait_time = initial_spawn_time
		timer_node.timeout.connect(_on_timer_timeout)
		print("✅ Timer inicial configurado: ", initial_spawn_time, "s")
	
	print("✅ Spawner configurado!")
	print("Pontos de spawn: ", spawn_points.size())
	print("Tipos de inimigos: ", enemy_scenes.size())
	print("=== FASES DA DIFICULDADE ===")
	print("0-", easy_phase_duration, "s: Só Easy")
	print(easy_phase_duration, "-", medium_phase_duration, "s: Easy + Medium")
	print(medium_phase_duration, "s+: Todos os tipos")

func _process(delta: float) -> void:
	game_time += delta
	update_timer_speed()

func update_timer_speed():
	if not timer_node:
		return
	
	# Calcula novo tempo do timer baseado no tempo de jogo
	var speed_multiplier = game_time / speed_increase_interval
	var new_wait_time = initial_spawn_time - (speed_multiplier * 0.2)  # Diminui 0.2s a cada intervalo
	
	# Limita ao tempo mínimo
	new_wait_time = max(new_wait_time, minimum_spawn_time)
	
	# Só atualiza se mudou significativamente (evita spam)
	if abs(timer_node.wait_time - new_wait_time) > 0.05:
		timer_node.wait_time = new_wait_time
		print("⚡ Timer atualizado: ", timer_node.wait_time, "s (tempo: ", int(game_time), "s)")

func _on_timer_timeout() -> void:
	spawn_progressive_enemy()

func spawn_progressive_enemy():
	if spawn_points.is_empty() or enemy_scenes.is_empty():
		print("❌ Erro: sem pontos de spawn ou inimigos!")
		return
	
	var random_spawn = spawn_points[randi() % spawn_points.size()]
	var enemy_index = get_progressive_enemy_index()
	
	var enemy_instance = enemy_scenes[enemy_index].instantiate()
	enemy_instance.position = random_spawn.position
	add_child(enemy_instance)
	
	var phase_name = get_current_phase_name()
	print("🎯 [", phase_name, "] Spawnou: ", enemy_names[enemy_index], " (", int(game_time), "s)")

func get_progressive_enemy_index() -> int:
	# Determina qual fase estamos
	if game_time <= easy_phase_duration:
		# FASE 1: 0-20s - Só Easy (índices 0, 1, 2)
		return randi() % 3
		
	elif game_time <= medium_phase_duration:
		# FASE 2: 20-60s - Easy + Medium com pesos
		var phase2_weights = [8, 8, 8, 5, 5, 5]  # Easy ainda mais comum
		return get_weighted_enemy(phase2_weights)
		
	else:
		# FASE 3: 60s+ - Todos os tipos com pesos balanceados
		var phase3_weights = [5, 5, 5, 7, 7, 7, 8, 8, 8]  # Hard mais comum no final
		return get_weighted_enemy(phase3_weights)

func get_weighted_enemy(weights: Array) -> int:
	var total_weight = 0
	for weight in weights:
		total_weight += weight
	
	var random_value = randi() % total_weight
	var current_weight = 0
	
	for i in range(weights.size()):
		current_weight += weights[i]
		if random_value < current_weight:
			return i
	
	return 0  # fallback

func get_current_phase_name() -> String:
	if game_time <= easy_phase_duration:
		return "EASY"
	elif game_time <= medium_phase_duration:
		return "MEDIUM"
	else:
		return "HARD"
