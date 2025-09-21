extends Node

var final_score: int = 0
var current_score: int = 0

func set_final_score(score: int):
	final_score = score
	print("Score final salvo: ", final_score)

func get_final_score() -> int:
	return final_score

func reset_score():
	current_score = 0
	final_score = 0
