extends Node2D

func end_turn():
	$TurnController.end_turn()

func _physics_process(delta):
	# Update visible mobs
	var visible_mobs = {}
	for player in $TurnController/PlayerTeam.get_children():
		for mob in player.visible_mobs:
			visible_mobs[mob] = null
	
	for mob in $TurnController/EnemyTeam.get_children():
		# TODO this hides mobs before their death animation and IDK how to fix it
		if not mob.dead and mob in visible_mobs:
			mob.show()
		else:
			mob.hide()
	
func _input(event):
	if event is InputEventMouseButton \
				and event.button_index == MOUSE_BUTTON_LEFT \
				and event.pressed:
		
		var p = PhysicsPointQueryParameters2D.new()
		p.position = event.position
		p.collide_with_areas = true
		p.collision_mask = 1

		var nodes = get_world_2d().direct_space_state \
			.intersect_point(p)
			
		var targets = []
		for node in nodes:
			var target = node["collider"].get_parent()
			if target.find_child("MobProps") != null:
				targets.append(target)

		match targets.size():
			0: pass
			1: targets[0].handle_click()
			_:
				push_error("Multiple targets clicked")
				for t in targets:
					t.handle_click()
