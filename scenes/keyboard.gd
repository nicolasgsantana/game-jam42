extends Node2D

var keys: Dictionary[int, Node2D]

func _ready() -> void:
	for child in $Keys.get_children():
		keys[child.get_meta("keycode")] = child
	print(keys)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not keys.get(event.keycode):
			return
		if event.is_pressed():
			update_to_pressed(event.keycode)
		if event.is_released():
			update_to_normal(event.keycode)

func update_to_pressed(keycode) -> void:
	var normal_key: Sprite2D = keys[keycode].get_children()[0]
	var pressed_key: Sprite2D = keys[keycode].get_children()[1]
	if normal_key.visible:
		normal_key.visible = false
	if not pressed_key.visible:
		pressed_key.visible = true

func update_to_normal(keycode) -> void:
	var normal_key: Sprite2D = keys[keycode].get_children()[0]
	var pressed_key: Sprite2D = keys[keycode].get_children()[1]
	if not normal_key.visible:
		normal_key.visible = true
	if pressed_key.visible:
		pressed_key.visible = false
