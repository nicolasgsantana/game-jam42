extends Node2D

@onready var falas := $CanvasLayer.get_children()  # pega todos os RichTextLabel
var tween = null  # tween ativo

func mostrar_fala(indice: int, duracao: float = 2.0) -> void:
	# 1️⃣ Esconde todas as falas
	for fala in falas:
		fala.visible = false
		fala.visible_characters = 0
	
	# 2️⃣ Mostra apenas a fala escolhida
	if indice >= 0 and indice < falas.size():
		var fala_label: RichTextLabel = falas[indice]
		fala_label.visible = true
		
		var total := fala_label.get_total_character_count()
		
		# 3️⃣ Mata tween anterior (se houver)
		if tween != null and tween.is_valid():
			tween.kill()
		
		# 4️⃣ Cria tween para animação gradual da esquerda para a direita
		tween = get_tree().create_tween()
		tween.tween_property(
			fala_label, "visible_characters", total, duracao
		).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
