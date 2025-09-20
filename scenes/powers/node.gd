extends Node

var lifes: int = 3
var max_lifes: int = 3
var can_recover: bool = true

func _ready() -> void:
	print("Vidas iniciais:", lifes)

func _input(event):
	#$"../Vidas".text = str("Vidas: ",lifes)
	if lifes == 3:
		$"../duck".show()
		$"../duck2".show()
		$"../duck3".show()
	if lifes == 2:
		$"../duck2".show()
		$"../duck3".hide()
	if lifes == 1:
		$"../duck2".hide()
	if can_recover:
		$"../PowerLife/power_life_on".show()
		$"../PowerLife/power_life_off".hide()
	else:
		$"../PowerLife/power_life_on".hide()
		$"../PowerLife/power_life_off".show()
	if event is InputEventKey and event.pressed:
		var c = char(event.unicode)
		match c:
			"7":
				lost_life()
			"1":
				recover_life()
	print(can_recover)

func lost_life() -> void:
	if lifes > 0:
		lifes -= 1
		print("Perdeu uma vida! Restam:", lifes)
	else:
		print("Game Over!")

func recover_life() -> void:
	if can_recover and lifes < max_lifes:
		lifes += 1
		print("Recuperou uma vida! Agora tem: ", lifes)
		can_recover = false
		$RecoverTime.start()
	else:
		print("Você não pode recuperar vida agora.")
		
func _on_recover_time_timeout() -> void:
	can_recover = true
	print("Pode recuperar vida novamente!")
