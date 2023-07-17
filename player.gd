extends Node2D

@export var walking_speed = 50.0
@export var movement_range = 300.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

signal turn_ended

var starting_pos: Vector2

enum STATE {WAITING, MOVING, CASTING}

var state = STATE.WAITING

var health = 100.0 : set = _set_health, get = _get_health
var max_health = 124.0

func _get_health():
	return health
	
func _set_health(new_health):
	health = new_health
	$HealthBar.value = health / max_health

# Called when the node enters the scene tree for the first time.
func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	$RangeMarker.radius = movement_range
	$HealthBar.value = health / max_health

func set_navigation_map(m: RID):
	navigation_agent.set_navigation_map(m)
	
func start_turn():
	state = STATE.MOVING
	
	# Set up range marker
	starting_pos = position
	$RangeMarker.position = starting_pos - position
	$RangeMarker.queue_redraw()
	$RangeMarker.show()
	
	highlight(Color.GREEN)
	
func end_turn():
	state = STATE.WAITING
	$RangeMarker.hide()
	unhighlight()
	turn_ended.emit()

func highlight(color: Color):
	$SelectionCircle.color = color
	$SelectionCircle.show()

func unhighlight():
	$SelectionCircle.hide()

	
func right_click(movement_target: Vector2):
	if state == STATE.MOVING:
		# Clip target to within movement range
		if starting_pos.distance_to(movement_target) > movement_range:
			return
		
		navigation_agent.target_position = movement_target
		$AnimationPlayer.play("walk")
		if movement_target.x < transform.get_origin().x:
			$BodySprite.flip_h = true
			$HairSprite.flip_h = true
			$ShirtSprite.flip_h = true
			$PantsSprite.flip_h = true
			$ShoeSprite.flip_h = true
		else:
			$BodySprite.flip_h = false
			$HairSprite.flip_h = false
			$ShirtSprite.flip_h = false
			$PantsSprite.flip_h = false
			$ShoeSprite.flip_h = false
	elif state == STATE.CASTING:
		state = STATE.MOVING
		$BeamSpell.finish()

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		$AnimationPlayer.stop(false)
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
	
	$RangeMarker.position = starting_pos - position

func _input(event):
	if state == STATE.MOVING:
		if event.is_action_pressed("cast1"):
			state = STATE.CASTING
			$BeamSpell.targeting()

		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			right_click(event.position)
