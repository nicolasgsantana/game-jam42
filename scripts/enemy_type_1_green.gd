extends CharacterBody2D

@export var speed: int = 200
@export var difficulty: int = 2
var is_dead: bool = false
var command: String

func _ready():
	add_to_group("enemies")
	var animated_sprite = get_node_or_null("AnimatedSprite2D")
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
	var animated_sprite: AnimatedSprite2D
	for child in get_children():
		if child is AnimatedSprite2D:
			animated_sprite = child
		else:
			child.visible = false
	animated_sprite.stop()
	animated_sprite.play("Death")
	await animated_sprite.animation_finished
	queue_free()

func word_feedback(buffer: Array) -> void:
	var player_input: String = ""
	for c in buffer:
		player_input += char(c)
	if player_input in command:
		$Control/CorrectLabel.text = player_input
	else:
		$Control/CorrectLabel.text = ""

func check_command(received_command: String) -> bool:
	if command == received_command:
		die()
		return true
	return false
