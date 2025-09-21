extends CharacterBody2D

@export var speed: int = 200
@export var difficulty: int = 1
var is_dead: bool = false
var command: String

func _ready():
	add_to_group("enemies")

	for child in get_children():
		if child is AnimatedSprite2D:
			var animated_sprite = child as AnimatedSprite2D
			print("    Animações do AnimatedSprite2D:")
	var animated_sprite = get_node_or_null("AnimatedSprite2D")
	if animated_sprite and animated_sprite.sprite_frames:
		if animated_sprite.sprite_frames.has_animation("Walk"):
			animated_sprite.play("Walk")
	
	var possible_commands: Array
	var command_dict: Dictionary = GlobalData.command_dict
	for command in command_dict:
		if command_dict[command] == difficulty:
			possible_commands.append(command)
	command = possible_commands[randi() % possible_commands.size()]
	$Control/CommandLabel.text = command

func _process(delta: float) -> void:
	# Só se move se não estiver morto
	if not is_dead:
		position += Vector2.LEFT * speed * delta

		if position.x < -100:
			queue_free()

func die():
	is_dead = true
	
	var animated_sprite = get_node_or_null("AnimatedSprite2D")
	
	if animated_sprite and animated_sprite.sprite_frames:
		var death_anim_name = ""
		if animated_sprite.sprite_frames.has_animation("Death"):
			death_anim_name = "Death"
		if death_anim_name != "":
			print("✅ Encontrou animação de morte: '", death_anim_name, "'")
			
			# IMPORTANTE: Para a animação atual primeiro
			animated_sprite.stop()
			
			# Toca a animação de morte
			animated_sprite.play(death_anim_name)
			
			# Verifica se a animação faz loop
			var is_looping = animated_sprite.sprite_frames.get_animation_loop(death_anim_name)
			print("Animação Death faz loop: ", is_looping)
			
			if is_looping:
				print("⚠️  AVISO: Animação Death está marcada como LOOP!")
				print("⚠️  Vá no AnimatedSprite2D e desmarque 'Loop' na animação Death")
				# Remove após um tempo fixo se estiver em loop
				await get_tree().create_timer(1.0).timeout
				print("✅ Timeout atingido, removendo inimigo...")
				queue_free()
			else:
				# Espera a animação terminar normalmente
				print("⏳ Aguardando animação Death terminar...")
				await animated_sprite.animation_finished
				print("✅ Animação terminou! Removendo inimigo...")
				queue_free()
		else:
			print("❌ Animação de morte não encontrada! Usando efeito simples...")
			simple_death_effect()
	else:
		print("❌ AnimatedSprite2D não encontrado! Usando efeito simples...")
		simple_death_effect()

func simple_death_effect():
	# Efeito simples de morte sem AnimatedSprite2D
	var animated_sprite = get_node_or_null("AnimatedSprite2D")
	if animated_sprite:
		# Cria um tween para fazer o efeito
		var tween = create_tween()
		tween.parallel().tween_property(animated_sprite, "modulate", Color.RED, 0.2)
		tween.parallel().tween_property(animated_sprite, "rotation", deg_to_rad(180), 0.5)
		tween.parallel().tween_property(animated_sprite, "scale", Vector2.ZERO, 0.5)
		
		# Remove depois do efeito
		await tween.finished
		queue_free()
	else:
		# Se não tiver nem sprite, remove imediatamente
		queue_free()

func word_feedback(buffer: Array) -> void:
	var player_input: String = ""
	for c in buffer:
		player_input += char(c)
	if player_input in command:
		$Control/CorrectLabel.text = player_input
	else:
		$Control/CorrectLabel.text

func check_command(received_command: String) -> bool:
	if command == received_command:
		die()
		return true
	return false
