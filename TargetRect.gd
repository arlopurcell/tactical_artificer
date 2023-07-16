extends Node2D

var range = 200.0 : set = _set_range, get = _get_range
var width = 10.0 : set = _set_width, get = _get_width

func _set_range(new_range):
	range = new_range
	queue_redraw()
	
func _get_range():
	return range
	
func _set_width(new_width):
	width = new_width
	queue_redraw()
	
func _get_width():
	return width


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	pass

func _draw():
	var r = Rect2(Vector2(0.0, -width / 2), Vector2(range, width))
	draw_rect(r, Color.WHITE)
