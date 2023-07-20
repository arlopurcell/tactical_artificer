extends Node

var turn_index = 0

signal turn_ended

func _ready():
	for child in get_children():
		child.turn_ended.connect(_on_turn_ended)
	
func start_turn():
	print("enemy turn")
	turn_index = -1
	_on_turn_ended()

func _on_turn_ended():
	turn_index = turn_index + 1
	if turn_index >= get_child_count():
		turn_ended.emit()
	else:
		var child = get_child(turn_index)
		if child.dead:
			_on_turn_ended()
		else:
			child.start_turn()
