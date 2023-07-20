extends "res://mob.gd"

enum STATE {WALKING, READY, CASTING}
var active = false

var state = STATE.READY

func _ready():
	$MobProps.healthbar_color = Color.GREEN
	player_team = true
	super._ready()

func _on_navigation_finished():
	super._on_navigation_finished()
	state = STATE.READY
	
func anim_walk_left():
	$AnimationPlayer.play("walk")
	$BodySprite.flip_h = true
	$HairSprite.flip_h = true
	$ShirtSprite.flip_h = true
	$PantsSprite.flip_h = true
	$ShoeSprite.flip_h = true

func anim_walk_right():
	$AnimationPlayer.play("walk")
	$BodySprite.flip_h = false
	$HairSprite.flip_h = false
	$ShirtSprite.flip_h = false
	$PantsSprite.flip_h = false
	$ShoeSprite.flip_h = false

func anim_idle():
	$AnimationPlayer.play("walk")
	$AnimationPlayer.stop(false)

func anim_damage():
	# TODO
	pass

func anim_death():
	pass
	
func _input(event):
	if not active:
		return
	
	if event is InputEventMouseButton:
		if event.pressed:
			match [event.button_index, state]:
				[MOUSE_BUTTON_RIGHT, STATE.READY], [MOUSE_BUTTON_RIGHT, STATE.WALKING]:
					state = STATE.WALKING
					move_to(event.position)
				[MOUSE_BUTTON_RIGHT, STATE.CASTING]:
					state = STATE.READY
					$BeamSpell.finish()
				[MOUSE_BUTTON_LEFT, STATE.CASTING]:
					for mob in $BeamSpell.targetted:
						mob.get_parent().damage($BeamSpell.damage)
					$BeamSpell.finish()
					end_turn()
	elif event.is_action_pressed("cast1"):
		match state:
			STATE.READY, STATE.CASTING:
				state = STATE.CASTING
				$BeamSpell.targeting()

func handle_click():
	get_parent().deactivate_all()
	active = true
	state = STATE.READY
	$MobProps.highlight(Color.LIGHT_BLUE)

func deactivate():
	active = false
	$MobProps.unhighlight()
	$BeamSpell.finish()
	
