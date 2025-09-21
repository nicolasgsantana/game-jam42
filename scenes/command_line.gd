extends Node2D

func _on_input_handler_buffer_changed(buffer: Array) -> void:
	var player_input: String = ""
	
	for c in buffer:
		player_input += char(c)
	$Control/ColorRect/PlayerInput.text = player_input
