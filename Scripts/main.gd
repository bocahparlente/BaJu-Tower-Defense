extends Node3D

var enemy_scene = preload("res://Scenes/Mesh/Enemy/enemy_mouse.tscn")

func _ready() -> void:
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	$Path3D.add_child(enemy)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var camera = $Camera3D
		var mouse_pos = get_viewport().get_mouse_position()

		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_direction = camera.project_ray_normal(mouse_pos)
		var ray_end = ray_origin + ray_direction * 1000

		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		var result = space_state.intersect_ray(query)

		if result:
			place_marker(result.position)

func place_marker(pos: Vector3) -> void:
	var marker = MeshInstance3D.new()
	marker.mesh = BoxMesh.new()
	marker.mesh.size = Vector3(0.5, 0.5, 0.5)
	marker.position = pos
	add_child(marker)

func tower_built() -> void:
	print("Tower placed!")	
