extends Node2D

var height = 5.0
var width = 35.0

@export var color = Color.RED : set = _set_color, get = _get_color
	
func _set_color(new_color):
	color = new_color
	queue_redraw()
	
func _get_color():
	return color

var value = 1.0 : set = _set_value, get = _get_value

func _get_value():
	return value
	
func _set_value(new_value):
	value = new_value
	queue_redraw()


func _draw():
	draw_rect(Rect2(Vector2(-18., 29.), Vector2(width + 2., height + 2.)), Color.BLACK)
	draw_rect(Rect2(Vector2(-17., 30.), Vector2(width * value, height)), color)



