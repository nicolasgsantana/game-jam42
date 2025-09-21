# life.gd
extends Node

var lifes: int = 3
var max_lifes: int = 3
var can_recover: bool = true
var bar_life: AnimatedSprite2D
@onready var sfx_quack = $sfx_quack
@onready var sfx_quack2 = $sfx_quack2
@onready var sfx_quack3 = $sfx_quack3

func _ready() -> void:
	print("Vidas iniciais:", lifes)
	bar_life = get_node("../Player/barlife")

func update_visual():
	if lifes == 3:
		$"duck".show()
		$"duck2".show()
		$"duck3".show()
	if lifes == 2:
		$"duck2".show()
		$"duck3".hide()
		sfx_quack.play()
	if lifes == 1:
		$"duck2".hide()
		sfx_quack2.play()
	if lifes == 0:
		$"duck".hide()
		sfx_quack3.play()
		await get_tree().create_timer(0.5).timeout
		trigger_game_over()
		
	if can_recover:
		$"PowerLife/power_life_on".show()
		$"PowerLife/power_life_off".hide()
	else:
		$"PowerLife/power_life_on".hide()
		$"PowerLife/power_life_off".show()
	print(can_recover)

func lost_life() -> void:
	if lifes > 0:
		lifes -= 1
		print("Perdeu uma vida! Restam:", lifes)
		update_visual()  # Movi para DEPOIS do print para debug
	else:
		print("Game Over!")
		# Caso já esteja em 0, chama game over diretamente
		trigger_game_over()

func trigger_game_over():
	print("=== TRIGGER GAME OVER CHAMADO ===")
	
	# Pegar score do GameManager
	var game_manager = get_node("../GameManager")
	var final_score = game_manager.player_score
	print("Score obtido: ", final_score)
	
	# Salvar no GameData (se existir)
	if GameData:
		GameData.set_final_score(final_score)
		print("Score salvo no GameData")
	
	# Ir para GameOver (vai funcionar agora que a cena existe!)
	get_tree().change_scene_to_file("res://scenes/GameOverScene.tscn")
	print("Indo para GameOver...")

func recover_life() -> void:
	if can_recover and lifes < max_lifes:
		lifes += 1
		print("Recuperou uma vida! Agora tem: ", lifes)
		can_recover = false
		$RecoverTime.start()
	else:
		print("Você não pode recuperar vida agora.")

func play_hit_effect():
	bar_life.play("hit")
	print("🔥 Tocando animação 'hit'!")
	
	await get_tree().create_timer(0.5).timeout
	
	bar_life.play("stand")
	print("✅ Voltou para animação 'stand'")

func _on_recover_time_timeout() -> void:
	can_recover = true
	print("Pode recuperar vida novamente!")
