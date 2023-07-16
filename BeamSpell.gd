extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target = get_viewport().get_mouse_position()
	var target_angle = global_position.direction_to(target).angle()
	$TargetRect.rotation = target_angle
	
func targeting():
	$TargetRect.visible = true

func finish():
	$TargetRect.visible = false
