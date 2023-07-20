extends Node

signal turn_ended

var players = []

func _ready():
	for child in get_children():
		if child.find_child("MobProps") != null:
			if child.player_team:
				players.append(child)
			else:
				push_error("Child of PlayerTeam has player_team == false")
		else:
			push_error("Child of PlayerTeam does not have MobProps?")
	
func deactivate_all():
	for player in players:
		player.deactivate()
	

func start_turn():
	print("player's turn")
	for player in players:
		player.start_turn()

	# Activate the first non-dead player
	for player in players:
		if not player.dead:
			player.handle_click()
			return
	push_error("All the players are dead?")

func end_turn():
	for player in players:
		player.end_turn()
	turn_ended.emit()
