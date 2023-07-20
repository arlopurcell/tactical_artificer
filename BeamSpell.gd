extends Area2D

var range = 200.0 : set = _set_range, get = _get_range
var width = 10.0 : set = _set_width, get = _get_width
var damage = 20.0

enum STATE {HIDDEN, TARGETING}

var state = STATE.HIDDEN

var targetted = {}

func _ready():
	range = 200.0
	width = 10.0
	self.area_entered.connect(_on_area_entered)
	self.area_exited.connect(_on_area_exited)
	
func _on_area_entered(area):
	# TODO if it's a targetable thing
	if state == STATE.TARGETING and area != get_parent().find_child("MobProps"):
		if area.find_child("MobProps") != null:
			targetted[area] = null
			area.highlight(Color.RED)

func _on_area_exited(area):
	if state == STATE.TARGETING and area != get_parent().find_child("MobProps"):
		if area.find_child("MobProps") != null:
			targetted.erase(area)
			area.unhighlight()
	
func _set_range(new_range):
	range = new_range
	$TargetRect.range = range
	$CollisionShape2D.shape.size.y = range

func _get_range():
	return range
	
func _set_width(new_width):
	width = new_width
	$TargetRect.width = width
	$CollisionShape2D.shape.size.x = width

func _get_width():
	return width

func _process(_delta):
	var target = get_viewport().get_mouse_position()
	var target_angle = global_position.direction_to(target).angle()
	rotation = target_angle
	
func targeting():
	$TargetRect.visible = true
	state = STATE.TARGETING
	for d in get_world_2d().direct_space_state.intersect_shape(collision_params()):
		_on_area_entered(d["collider"])

func finish():
	for d in get_world_2d().direct_space_state.intersect_shape(collision_params()):
		_on_area_exited(d["collider"])
	$TargetRect.visible = false
	state = STATE.HIDDEN

func collision_params():
	var params = PhysicsShapeQueryParameters2D.new()
	params.collide_with_areas = true
	params.collision_mask = collision_mask
	params.exclude = [get_parent().get_rid()]
	params.shape = $CollisionShape2D.shape
	params.transform = $CollisionShape2D.global_transform
	return params
