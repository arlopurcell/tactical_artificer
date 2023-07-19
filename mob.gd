extends Area2D

@export var walking_speed = 50.0
@export var movement_range = 300.0

@onready 
var navigation_agent: NavigationAgent2D = $NavigationAgent2D

signal turn_ended

var starting_pos: Vector2

var health = 100.0 : set = _set_health, get = _get_health
var max_health = 124.0

func _get_health():
	return health
	
func _set_health(new_health):
	health = new_health
	$HealthBar.value = health / max_health
	
func damage(value):
	anim_damage()
	var new_health = health - value
	if new_health <= 0:
		new_health = 0
		anim_die()
		# TODO death
	health = new_health

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	$HealthBar.value = health / max_health

func set_navigation_map(m: RID):
	navigation_agent.set_navigation_map(m)

func start_turn():
	print("starting turn in mob")
	pass

func end_turn():
	turn_ended.emit()

func highlight(color: Color):
	$SelectionCircle.color = color
	$SelectionCircle.show()

func unhighlight():
	$SelectionCircle.hide()

func anim_walk_left():
	pass

func anim_walk_right():
	pass

func anim_idle():
	pass

func anim_damage():
	pass

func anim_die():
	pass

func move_to(movement_target: Vector2):
	# TODO check this out it looks wrong. remove?
	if starting_pos.distance_to(movement_target) > movement_range:
		return
	
	navigation_agent.target_position = movement_target
	if movement_target.x < transform.get_origin().x:
		anim_walk_left()
	else:
		anim_walk_right()

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		anim_idle()
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
