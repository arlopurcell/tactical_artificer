extends Node2D

@export var radius = 10.0 : set = _set_radius, get = _get_radius

var point_count = 200

func _draw():
	draw_arc(Vector2.ZERO, radius, 0, 2 * PI, point_count, Color.WHITE)
	
func _set_radius(new_radius):
	radius = new_radius
	queue_redraw()
	
func _get_radius():
	return radius

