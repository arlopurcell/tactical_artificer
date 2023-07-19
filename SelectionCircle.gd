extends Node2D

@export var color = Color.BLUE : set = _set_color, get = _get_color

var radius = 20.0

func _draw():
	draw_circle(Vector2.ZERO, radius, color)

	
func _set_color(new_color):
	color = new_color
	queue_redraw()
	
func _get_color():
	return color
