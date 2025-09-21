# GameOver.gd - Anexe este script ao Control da sua GameOver.tscn
extends Control

func _ready():
	print("=== GAMEOVER SCENE CARREGADA ===")
	
	# Debug: Verificar se GameData existe
	if GameData:
		print("GameData encontrado!")
		var score = GameData.get_final_score()
		print("Score recuperado do GameData: ", score)
	else:
		print("ERRO: GameData não encontrado!")
		var score = 0
	
	# Debug: Listar todos os filhos para encontrar o TextRect
	print("Filhos disponíveis:")
	for child in get_children():
		print("- ", child.name, " (", child.get_class(), ")")
	
	# Tentar encontrar o TextRect
	var text_rect = null
	
	# Método 1: Nome exato
	if has_node("TextRect"):
		text_rect = $TextRect
		print("TextRect encontrado pelo nome!")
	# Método 2: Buscar por tipo
	else:
		for child in get_children():
			if child is RichTextLabel or child is Label:
				text_rect = child
				print("Texto encontrado: ", child.name)
				break
	
	if text_rect:
		var score = GameData.get_final_score() if GameData else 0
		text_rect.text = "GAME OVER\n\nScore Final: " + str(score)
		print("Texto definido: ", text_rect.text)
		
		# Tentar aumentar fonte
		if text_rect.has_method("add_theme_font_size_override"):
			text_rect.add_theme_font_size_override("font_size", 48)
			print("Fonte aumentada para 48")
	else:
		print("ERRO: Nenhum componente de texto encontrado!")
	
	print("GameOver carregado! Score: ", GameData.get_final_score() if GameData else 0)


func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://main_menu.tscn")
