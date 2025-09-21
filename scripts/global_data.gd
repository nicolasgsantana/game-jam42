extends Node

# String is the command
# int is the difficulty
var command_dict: Dictionary[String, int] = {
	"LS": 1,
	"CD": 1,
	"PWD": 1,
	"RM": 1,
	"MKDIR": 2,
	"RM -RF": 2,
	"LS -LA": 2,
	"RMDIR": 2,
	"TAR -XVF": 3,
	"CHMOD -R": 3,
	"ECHO -E": 3,
	"KILL -L": 3
}
