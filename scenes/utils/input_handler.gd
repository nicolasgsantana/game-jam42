extends Node


## A buffer of previous entered key codes
var buffer: Array = []

## The configured text and the commands to trigger
var sequences: Dictionary[String, Callable] = {
	"LS": _seq_lol,
	"RM -RF": _seq_brb,
	"GERALT OF RIVIA": _seq_brb
}

## The processed sequences, converted from string to an array of ascii keys
var _sequences: Dictionary[Array, Callable] = {}

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
		_check_sequence(buffer)


func _build_sequences() -> void:
	_sequences.clear()
	max_sequence_length = 0
	for sequence in sequences:
		_sequences[Array(sequence.to_ascii_buffer())] = sequences[sequence]
		if max_sequence_length < sequence.length():
			max_sequence_length = sequence.length()
	
	print(sequences, _sequences)


func _check_sequence(buffer: Array) -> void:
	var possible_sequences: int = 0
	for sequence in _sequences:
		if buffer == sequence.slice(0, buffer.size()):
			possible_sequences += 1
	print("Possible sequences ", possible_sequences)
	if possible_sequences == 0:
		print("Buffer cleared")
		buffer.clear()


func _confirm_sequence(buffer: Array) -> void:
	for sequence in _sequences:
		if sequence == buffer.slice(-sequence.size()):
			_sequences[sequence].call()
			buffer.clear()


func _seq_lol() -> void:
	print("Laughing out loud!")


func _seq_brb() -> void:
	print("Be right back!")
	
