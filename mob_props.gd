extends Area2D

@export 
var healthbar_color: Color = Color.GREEN : set = _set_healthbar_color, get = _get_healthbar_color

@onready
var vision_area = $Vision/VisionArea2D

func _set_healthbar_color(new_healthbar_color):
	healthbar_color = new_healthbar_color
	$HealthBar.color = new_healthbar_color
	
func _get_healthbar_color():
	return healthbar_color

func highlight(color: Color):
	$SelectionCircle.color = color
	$SelectionCircle.show()

func unhighlight():
	$SelectionCircle.hide()
