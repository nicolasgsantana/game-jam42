extends NinePatchRect

@onready var text = $text as RichTextLabel
@onready var timer = $Timer

var msg_queue: Array = [
	"Olá",
	"Diálogo Marvin"
]
var current_message_length: int = 0

func _input(event):
	if event is InputEventKey and event.is_action_pressed("ui_accept"):
		show_message()

func show_message() -> void:
	if not timer.is_stopped():
		text.visible_characters = current_message_length
		return
	if msg_queue.size() == 0:
		hide()
		return
	
	var _msg: String = msg_queue.pop_front()
	
	text.visible_characters = 0
	text.text = _msg
	# Força a atualização do texto para calcular o comprimento correto
	await get_tree().process_frame
	current_message_length = text.get_total_character_count()
	timer.start()

func _on_timer_timeout():
	if text.visible_characters >= current_message_length:
		timer.stop()
		return
	
	text.visible_characters += 1
