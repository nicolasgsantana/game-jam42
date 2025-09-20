extends Area2D

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		print("Inimigo entrou na área: ", body.name)

func _on_body_exited(body):
	if body.is_in_group("enemies"):
		print("Inimigo saiu da área: ", body.name)
