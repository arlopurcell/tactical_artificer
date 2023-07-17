extends Node2D

var height = 5.0
var width = 35.0

var value = 1.0 : set = _set_value, get = _get_value

func _get_value():
	return value
	
func _set_value(new_value):
	value = new_value
	queue_redraw()


func _draw():
	draw_rect(Rect2(Vector2(-18., 29.), Vector2(width + 2., height + 2.)), Color.BLACK)
	draw_rect(Rect2(Vector2(-17., 30.), Vector2(width * value, height)), Color.RED)



