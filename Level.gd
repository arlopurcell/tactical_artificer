extends Node2D

func _ready():
	call_deferred("start_turn")


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		$Player.right_click(event.position)

func start_turn():
	$Player.start_turn()
	$PlayerRangeMarker.position = $Player.starting_pos
	$PlayerRangeMarker.radius = $Player.movement_range

func _on_end_turn():
	# TODO do ai turns
	print("_on_end_turn")
	start_turn()
