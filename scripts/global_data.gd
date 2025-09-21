extends Node

# String is the command
# int is the difficulty
var command_dict: Dictionary[String, int] = {
	"LS": 1,
	"CD": 1,
	"RM -RF": 2,
	"PWD": 1,
	"WHOAMI": 2
}
