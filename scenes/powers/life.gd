# life.gd
extends Node

var lifes: int = 3
var max_lifes: int = 3
var can_recover: bool = true
var bar_life: AnimatedSprite2D

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
	if lifes == 1:
		$"duck2".hide()
	if lifes == 0:
		$"duck".hide()
		# Chamar game over quando lifes == 0
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
		update_visual()
		print("Perdeu uma vida! Restam:", lifes)
	else:
		print("Game Over!")

func trigger_game_over():
	# Pegar referência do GameManager para obter o score
	var game_manager = get_node("../GameManager")
	var final_score = game_manager.player_score
	
	# Pegar referência da tela de game over
	var game_over_screen = get_node("../GameOverScreen")
	
	# Pausar o jogo
	get_tree().paused = true
	
	# Mostrar tela de game over com o score
	#game_over_screen.show_game_over(final_score)

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
