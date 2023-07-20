extends Node2D

@export var walking_speed = 100.0
@export var movement_range = 300.0

@onready
var props = $MobProps

@onready 
var navigation_agent: NavigationAgent2D = mp("NavigationAgent2D")

signal turn_ended

var starting_pos: Vector2

var health = 100.0 : set = _set_health, get = _get_health
var max_health = 124.0

var dead = false

var player_team = false

var visible_mobs = {}

func _get_health():
	return health
	
func mp(prop: String):
	# TODO refactor to use $MopProps/HealthBar syntax
	return props.find_child(prop)
	
func _set_health(new_health):
	health = new_health
	mp("HealthBar").value = health / max_health
	
func damage(value):
	anim_damage()
	var new_health = health - value
	if new_health <= 0:
		new_health = 0
		die()
	health = new_health

func die():
	anim_death()
	dead = true

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	navigation_agent.navigation_finished.connect(_on_navigation_finished)
	
	mp("HealthBar").value = health / max_health
	mp("RangeMarker").radius = movement_range
	
	props.vision_area.area_entered.connect(area_entered_vision)
	props.vision_area.area_exited.connect(area_exited_vision)
	
func area_entered_vision(area):
	var parent = area.get_parent()
	if parent.find_child("MobProps") != null and parent.dead == false:
		visible_mobs[parent] = null

func area_exited_vision(area):
	visible_mobs.erase(area.get_parent())

func set_navigation_map(m: RID):
	navigation_agent.set_navigation_map(m)
	
func _on_navigation_finished():
	anim_idle()

func start_turn():
	# Set up range marker
	starting_pos = position
	
	mp("RangeMarker").position = starting_pos - position
	mp("RangeMarker").queue_redraw()
	mp("RangeMarker").show()

func end_turn():
	mp("RangeMarker").hide()
	turn_ended.emit()

func anim_walk_left():
	pass

func anim_walk_right():
	pass

func anim_idle():
	pass

func anim_damage():
	pass

func anim_death():
	pass

func move_to(movement_target: Vector2):
	navigation_agent.target_position = movement_target
	if movement_target.x < transform.get_origin().x:
		anim_walk_left()
	else:
		anim_walk_right()

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var travel_raw = navigation_agent.get_next_path_position() - position
	var travel
	if travel_raw.length() < walking_speed * delta:
		travel = travel_raw
	else:
		travel = (travel_raw).normalized() * walking_speed * delta
	
	if starting_pos.distance_to(position + travel) > movement_range:

		navigation_agent.target_position = position
	else:
		translate(travel)

	mp("RangeMarker").position = starting_pos - position
	
func handle_click():
	pass
