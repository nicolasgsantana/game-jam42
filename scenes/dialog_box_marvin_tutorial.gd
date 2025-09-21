extends NinePatchRect

@onready var text = $RichTextLabel
@onready var timer = $Timer

var msg_queue: Array = [
	" " +
	" " +
	"De novo.",
	"Sim, sua vida depende de pressionar teclas corretamente. " +
	"Estou tão entusiasmado quanto você imagina... menos, talvez.",
	"Olhe, humano. Se você não digitar os comandos corretos, " +
	"os monstros vão continuar destruindo seus projetos. " +
	"Nada pessoal."
]

var current_message: String = ""
var is_typing: bool = false

func _input(event):
	if event is InputEventKey and event.is_action_pressed("ui_accept"):
		if is_typing:
			# Completa a mensagem atual
			text.visible_characters = -1  # Mostra todo o texto
			timer.stop()
			is_typing = false
		else:
			# Avança para próxima mensagem
			show_next_message()

func show_next_message():
	if msg_queue.size() == 0:
		hide()
		return
	
	current_message = msg_queue.pop_front()
	text.text = current_message
	text.visible_characters = 0
	is_typing = true
	
	timer.start(0.05)

func _on_timer_timeout():
	if text.visible_characters < text.get_total_character_count():
		text.visible_characters += 1
	else:
		timer.stop()
		is_typing = false
