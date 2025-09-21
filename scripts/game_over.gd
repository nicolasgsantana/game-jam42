# GameOverScreen.gd
extends Control

@export var score_label: Label
@export var final_score_label: Label
var display_timer: Timer

func _ready():
	# Criar o timer
	display_timer = Timer.new()
	add_child(display_timer)
	display_timer.wait_time = 3.0
	display_timer.one_shot = true
	display_timer.timeout.connect(_on_timer_timeout)

func show_game_over(final_score: int):
	# Mostrar a tela
	show()
	
	# Exibir o score final
	if final_score_label:
		final_score_label.text = "Score Final: " + str(final_score)
	
	# Iniciar o timer de 3 segundos
	display_timer.start()
	
	print("Game Over! Score final: ", final_score)

func _on_timer_timeout():
	# Após 3 segundos, você pode escolher o que fazer:
	# Opção 1: Voltar para o menu principal
	get_tree().change_scene_to_file("res://scenes/levels/main.tscn")
