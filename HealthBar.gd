extends Node2D

const height = 5.0
const width = 35.0

@export var color = Color.RED : set = _set_color, get = _get_color

func _set_color(new_color):
	color = new_color
	queue_redraw()
	
func _get_color():
	return color

var value = 1.0 : set = _set_value, get = _get_value
var damage_taken = 0. : set = _set_damage_taken, get = _get_damage_taken
var damage_countdown = 0.
const DAMAGE_DELAY = 0.8
const DAMAGE_DECAY = 0.4

func _get_value():
	return value
	
func _set_value(new_value):
	damage_taken = value - new_value
	damage_countdown = DAMAGE_DELAY
	value = new_value
	queue_redraw()
	
func _get_damage_taken():
	return damage_taken
	
func _set_damage_taken(new_damage_taken):
	damage_taken = new_damage_taken
	queue_redraw()
	
func _process(delta):
	if damage_taken > 0.:
		damage_countdown = max(damage_countdown - delta, 0.)
		if damage_countdown == 0.:
			damage_taken = max(damage_taken - DAMAGE_DECAY * delta, 0.)

func _draw():
	draw_rect(Rect2(Vector2(-width / 2. - 1., 29.), Vector2(width + 2., height + 2.)), Color.BLACK)
	draw_rect(Rect2(Vector2(-width / 2., 30.), Vector2(width * value, height)), color)
	draw_rect(Rect2(Vector2(-width / 2. + width * value, 30.), Vector2(damage_taken * width, height)), Color.WHITE)


