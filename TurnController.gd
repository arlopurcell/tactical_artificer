extends Node

var turn_index = 0

func _ready():
	call_deferred("start_turns")

func start_turns():
	for child in get_children():
		child.turn_ended.connect(_on_turn_ended)
	get_child(turn_index).start_turn()
	
func end_turn():
	# TODO disable end turn button if it's not the player turn
	get_child(turn_index).end_turn()
	
func _on_turn_ended():
	turn_index = (turn_index + 1) % get_child_count()
	get_child(turn_index).start_turn()
