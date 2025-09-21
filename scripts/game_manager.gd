# GameManager.gd - Coloque isso no nó principal da sua cena Main
extends Node

@export var score_label: Label   # Para mostrar a pontuação (opcional)

var current_input: String = ""
var player_score: int = 0
var combat_area: Area2D

func _ready():
	var main_node = get_parent()  # Assumindo que GameManager é filho do Main
	if main_node:
		print("Filhos do Main:")
		for child in main_node.get_children():
			print("  - ", child.name, " (", child.get_class(), ")")
	
	# Método 1: find_child com diferentes parâmetros
	combat_area = find_child("CombatArea", true, false)
	if main_node:
		combat_area = main_node.get_node_or_null("CombatArea")
		if combat_area:
			print("✅ Método 2 funcionou: CombatArea encontrada no Main!")
			return

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			check_command()
		# Verifica se é Backspace
		elif event.keycode == KEY_BACKSPACE:
			if current_input.length() > 0:
				current_input = current_input.substr(0, current_input.length() - 1)
				print("Input atual: ", current_input)
		# Adiciona caracteres normais
		elif event.unicode != 0:
			var character = char(event.unicode).to_lower()
			current_input += character
			print("Input atual: ", current_input)

func check_command():
	print("Comando digitado: ", current_input)
	
	if current_input.to_lower() == "green":
		execute_green_command()
	else:
		print("Comando inválido!")
	
	# Limpa o input
	current_input = ""

func execute_green_command():
	print("Executando comando GREEN!")
	
	# Pega APENAS os inimigos que estão DENTRO da área de combate
	var enemies_in_area = get_enemies_in_combat_area()
	
	if enemies_in_area.size() == 0:
		print("Nenhum inimigo na área de combate!")
		return
	
	print("Inimigos na área de combate: ", enemies_in_area.size())
	
	# Mata APENAS os inimigos que estão dentro da área
	for enemy in enemies_in_area:
		kill_enemy(enemy)
		print("Inimigo eliminado: ", enemy.name)

func get_enemies_in_combat_area() -> Array:
	var enemies = []
	
	if not combat_area:
		print("ERRO: Área de combate não encontrada!")
		return enemies
	
	# Pega APENAS os corpos que estão DENTRO da área de combate no momento
	var bodies_in_area = combat_area.get_overlapping_bodies()
	
	# Filtra APENAS os inimigos
	for body in bodies_in_area:
		if body.is_in_group("enemies") and not body.is_dead:
			enemies.append(body)
			print("Inimigo detectado na área: ", body.name)
	
	return enemies

func kill_enemy(enemy: Node):
	print("=== DEBUG KILL_ENEMY ===")
	print("Matando inimigo: ", enemy.name)
	print("Inimigo tem método die(): ", enemy.has_method("die"))
	print("is_dead antes de morrer: ", enemy.get("is_dead"))
	
	# Marca como morto primeiro
	if enemy.has_method("die"):
		print("✅ Chamando enemy.die()...")
		enemy.die()
		
		# IMPORTANTE: Espera um frame para garantir que die() foi processado
		await get_tree().process_frame
		
		print("is_dead depois de morrer: ", enemy.get("is_dead"))
		
		# Só adiciona pontuação se o inimigo não está mais vivo
		if enemy.get("is_dead") == true:
			print("✅ Inimigo morreu, adicionando pontuação...")
			add_score(1)
			print("✅ Pontuação adicionada! Score atual: ", player_score)
		else:
			print("❌ Inimigo não morreu corretamente (is_dead = ", enemy.get("is_dead"), ")")
	else:
		print("❌ Inimigo não tem método die()")
		# Tenta adicionar pontuação mesmo assim
		add_score(1)
		print("✅ Pontuação adicionada mesmo sem die()! Score atual: ", player_score)

func add_score(points: int):
	print("=== DEBUG ADD_SCORE ===")
	print("Pontos a adicionar: ", points)
	print("Score antes: ", player_score)
	
	player_score += points
	print("Score depois: ", player_score)
	
	# Atualiza UI se tiver
	if score_label:
		print("✅ Atualizando UI...")
		score_label.text = "Score: " + str(player_score)
		print("✅ Texto da UI: ", score_label.text)
	else:
		print("❌ ScoreLabel não encontrado! Verifique se foi configurado no inspector")
		
		# Tenta encontrar o label automaticamente
		var main_node = get_parent()
		if main_node:
			var ui_node = main_node.get_node_or_null("UI")
			if ui_node:
				var label = ui_node.get_node_or_null("ScoreLabel")
				if label:
					print("✅ ScoreLabel encontrado automaticamente!")
					score_label = label
					score_label.text = "Score: " + str(player_score)
				else:
					print("❌ ScoreLabel não encontrado em UI/ScoreLabel")
