extends "res://mob.gd"

enum STATE {WAITING, MOVING, CASTING}

var state = STATE.WAITING

	
func start_turn():
	super.start_turn()
	state = STATE.MOVING
	
	$MobProps.highlight(Color.LIGHT_BLUE)
	
func end_turn():
	state = STATE.WAITING
	$MobProps.unhighlight()
	$BeamSpell.finish()
	super.end_turn()

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

func anim_die():
	pass
	
func _input(event):
	if state == STATE.MOVING:
		if event.is_action_pressed("cast1"):
			state = STATE.CASTING
			$BeamSpell.targeting()

		elif event is InputEventMouseButton \
				and event.button_index == MOUSE_BUTTON_RIGHT \
				and event.pressed:
			move_to(event.position)
	elif state == STATE.CASTING:
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_RIGHT:
				state = STATE.MOVING
				$BeamSpell.finish()
			elif event.button_index == MOUSE_BUTTON_LEFT:
				for mob in $BeamSpell.targetted:
					mob.get_parent().damage($BeamSpell.damage)
				$BeamSpell.finish()
				end_turn()
