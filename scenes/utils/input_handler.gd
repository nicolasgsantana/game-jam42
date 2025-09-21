extends Node

signal buffer_changed(buffer: Array)
signal command_sent(command: Array, difficulty: int)

## A buffer of previous entered key codes
var buffer: Array = []

## The processed sequences, converted from string to an array of ascii keys
var _sequences: Dictionary[Array, int] = {}

## The longest sequence we need to handle
var max_sequence_length: int

func _ready() -> void:
	_build_sequences()


func _unhandled_input(event) -> void:
	var enter_keycode: int = 4194309
	if event is InputEventKey:
		if not event.is_pressed():
			return
		print("Pressed '%s', which is ascii code %d" % [event.key_label, event.keycode])
		
		if event.keycode != enter_keycode:
			buffer.append(event.keycode)
		if event.keycode == enter_keycode:
			_confirm_sequence(buffer)
			buffer_changed.emit(buffer)
		_check_sequence(buffer)
		buffer_changed.emit(buffer)


func _build_sequences() -> void:
	_sequences.clear()
	max_sequence_length = 0
	var command_dict: Dictionary = GlobalData.command_dict
	for sequence in command_dict:
		_sequences[Array(sequence.to_ascii_buffer())] = command_dict[sequence]
		if max_sequence_length < sequence.length():
			max_sequence_length = sequence.length()
	
	print(command_dict, _sequences)


func _check_sequence(local_buffer: Array) -> void:
	var possible_sequences: int = 0
	for sequence in _sequences:
		if local_buffer == sequence.slice(0, local_buffer.size()):
			possible_sequences += 1
	print("Possible sequences ", possible_sequences)
	if possible_sequences == 0:
		print("Buffer cleared")
		local_buffer.clear()


func _confirm_sequence(local_buffer: Array) -> void:
	for sequence in _sequences:
		if sequence == local_buffer.slice(-sequence.size()):
			command_sent.emit(sequence, _sequences[sequence])
	local_buffer.clear()
