extends Node2D

var _vision_points: PackedVector2Array
var _last_position = null

@export_range(0, 360) var angle_deg = 360
@export var ray_count = 100
@export var sight_range = 500.
@export_flags_2d_physics var collision_layer_mask: int = 1
@export var static_threshold: float = 2

@onready var _angle = deg_to_rad(angle_deg)
@onready var _angle_half = _angle/2.
@onready var _angular_delta = _angle / ray_count

@onready var collider = $Area2D.find_child("Collider")
@onready var renderer = $Renderer

func _physics_process(_delta: float) -> void:
	recalculate_vision()

func recalculate_vision():	
	var has_position_changed = _last_position == null or (global_position - _last_position).length() > static_threshold
	if not has_position_changed:
		return
	_last_position = global_position
	_vision_points.clear()
	_vision_points = calculate_vision_shape()
	collider.polygon = _vision_points
	renderer.polygon = _vision_points

func calculate_vision_shape():
	var new_vision_points = {}
	if _angle < 2*PI:
		new_vision_points[Vector2.ZERO] = null
	
	#var first_point = _ray_to(Vector2(0, sight_range).rotated(global_rotation - _angle_half))
	#var last_point = first_point
	for i in range(1, ray_count + 1): 
		
		# TODO following transform should be customizable
		var p = _ray_to(Vector2(0, sight_range).rotated(_angular_delta * i + global_rotation - _angle_half))
		new_vision_points[p] = null
		
		#var tri_points = PackedVector2Array()
		#tri_points.append_array([Vector2.ZERO, last_point, p])
		#draw_polygon(tri_points, colors)
	#if _angle < 2*PI:
	#	new_vision_points.append(Vector2.ZERO)
	return PackedVector2Array(new_vision_points.keys())
	
func _update_collision_polygon():
	var polygon = PackedVector2Array()
	polygon.append_array(_vision_points)
	#print(polygon)
	collider.polygon = polygon

func _update_render_polygon():
	var polygon = PackedVector2Array();
	polygon.append_array(_vision_points)
	renderer.polygon = polygon

func _ray_to(direction: Vector2) -> Vector2:
	# TODO add offset to origin
	var destination = global_position + direction
	var query = PhysicsRayQueryParameters2D.create(global_position, destination, collision_layer_mask)
	var collision = get_world_2d().direct_space_state.intersect_ray(query)

	var ray_position = collision["position"] if "position" in collision else destination
	return to_local(ray_position)
