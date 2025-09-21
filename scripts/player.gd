extends Area2D

var life_system: Node

func _ready():
	print("✅ Player pronto!")
	
	# Busca o sistema de vida
	life_system = get_node("../Life")
	if life_system:
		print("✅ Sistema de vida conectado!")
	
	# Conecta o sinal de colisão
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and not body.get("is_dead"):
		print("💥 Player foi atingido por: ", body.name)
		
		# Chama lost_life() no sistema de vida
		if life_system:
			life_system.lost_life()
		
		# Remove o inimigo
		if body.has_method("die"):
			body.die()
		else:
			body.queue_free()
