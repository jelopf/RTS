# camera_3d.gd

extends Camera3D

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var from = project_ray_origin(event.position)
		var to = from + project_ray_normal(event.position) * 1000
		var space_state = get_world_3d().direct_space_state
		var ray_params = PhysicsRayQueryParameters3D.new()
		ray_params.from = from
		ray_params.to = to
		ray_params.collide_with_areas = true
		ray_params.collide_with_bodies = true

		var result = space_state.intersect_ray(ray_params)

		if not result:
			return

		var clicked = result.collider

		if clicked and clicked.is_in_group("resource"):
			if clicked.has_method("is_clickable") and clicked.is_clickable():
				clicked.on_clicked()
				
		if clicked and clicked.is_in_group("enemy"):
			if clicked.has_method("on_clicked"):
				clicked.call("on_clicked")

			var selected_units = GameManager.get_selected_units()
			for unit in selected_units:
				if unit.has_method("set_attack_target"):
					unit.set_attack_target(clicked)

		if GameManager.ghost_building and clicked and clicked.is_in_group("ground"):
			PlacementManager.try_place_building(result.position)
