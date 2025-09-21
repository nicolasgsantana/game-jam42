# MainMenu.gd
extends Control

@export var play_button: Button
@export var quit_button: Button
@onready var sfx_mainmenu = $AudioStreamPlayer2D
func _ready():
	# Conectar os botões
	sfx_mainmenu.play()
	if play_button:
		play_button.pressed.connect(_on_play_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)
	
	print("Menu carregado!")

func _on_play_pressed():
	print("Iniciando o jogo...")
	get_tree().change_scene_to_file("res://scenes/levels/main.tscn")

func _on_quit_pressed():
	print("Saindo do jogo...")
	get_tree().quit()
