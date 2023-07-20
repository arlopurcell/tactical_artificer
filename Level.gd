extends Node2D

func _on_end_turn():
	$TurnController.end_turn()

func _input(event):
	if event is InputEventMouseButton \
				and event.button_index == MOUSE_BUTTON_LEFT \
				and event.pressed:
		
		var p = PhysicsPointQueryParameters2D.new()
		p.position = event.position
		p.collide_with_areas = true
		p.collision_mask = 1

		var targets = get_world_2d().direct_space_state\
			.intersect_point(p)

		match targets.size():
			0: pass
			1: targets[0]["collider"].get_parent().handle_click()
			_:
				push_error("Multiple targets clicked")
				for t in targets:
					t["collider"].get_parent().handle_click()
