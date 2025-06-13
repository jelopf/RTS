# PlacementManager.gd

extends Node

var ghost: Node3D = null  # Предпросмотр (прозрачный силуэт)
var current_type := 0  # Тип здания, например "type1"

func start_placement(type: int):
	GameManager.ghost_building = true
	current_type = type
	if ghost:
		ghost.queue_free()

	var scene_path = GameManager.barracks_data[type]["scene_path"]
	ghost = load(scene_path).instantiate()
	add_child(ghost)
	ghost.process_mode = Node.PROCESS_MODE_ALWAYS

func cancel_placement():
	if ghost:
		ghost.queue_free()
		ghost = null
	current_type = 0
	GameManager.ghost_building = false

func _process(_delta):
	if ghost:
		var mouse_pos = get_viewport().get_mouse_position()
		var from = get_viewport().get_camera_3d().project_ray_origin(mouse_pos)
		var to = from + get_viewport().get_camera_3d().project_ray_normal(mouse_pos) * 1000
		var space_state = get_viewport().get_camera_3d().get_world_3d().direct_space_state
		var ray_params = PhysicsRayQueryParameters3D.new()
		ray_params.from = from
		ray_params.to = to
		ray_params.collide_with_areas = true
		ray_params.collide_with_bodies = true
		var result = space_state.intersect_ray(ray_params)

		if result and result.collider.is_in_group("ground"):
			var grid_pos = GridManager.world_to_grid(result.position)
			var world_pos = GridManager.grid_to_world(grid_pos)
			ghost.global_transform.origin = world_pos


func try_place_building(world_position: Vector3):
	if not current_type or not ghost:
		return

	var grid_pos = GridManager.world_to_grid(world_position)

	if GridManager.is_cell_occupied(grid_pos):
		print("Клетка занята!")
		return

	var world_pos = GridManager.grid_to_world(grid_pos)

	var barracks = GameManager.create_barracks_instance(current_type)
	if not barracks:
		print("Недостаточно металла или ошибка создания казармы")
		return

	get_tree().current_scene.add_child(barracks)
	barracks.global_transform.origin = world_pos
	barracks.place_barracks()
	GridManager.occupy_cell(grid_pos)
	

	ghost.queue_free()
	ghost = null
	GameManager.ghost_building = false
	current_type = 0
	
	SoundManager.play_2d(AudioLibrary.sfx_build_barracks)



func _unhandled_input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		cancel_placement()

	if ghost and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		try_place_building(ghost.global_transform.origin)
