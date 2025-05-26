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

		# Всегда даём возможность кликнуть по ресурсу
		if clicked and clicked.is_in_group("resource"):
			if clicked.has_method("is_clickable") and clicked.is_clickable():
				clicked.on_clicked()

			
		# Клик по врагу
		if clicked and clicked.is_in_group("enemy") and clicked.has_method("on_clicked"):
			clicked.call("on_clicked")
			
		# Только если в режиме строительства — пробуем построить
		if GameManager.ghost_building and clicked and clicked.is_in_group("ground"):
			PlacementManager.try_place_building(result.position)
