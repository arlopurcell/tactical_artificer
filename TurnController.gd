extends Node

var turn_index = 0

func _ready():
	call_deferred("start_turns")

func start_turns():
	for child in get_children():
		child.turn_ended.connect(_on_turn_ended)
	get_child(turn_index).start_turn()
	
func end_turn():
	get_child(turn_index).end_turn()
	
func _on_turn_ended():
	turn_index = (turn_index + 1) % get_child_count()
	var child = get_child(turn_index)
	if child.dead:
		_on_turn_ended()
	else:
		child.start_turn()
