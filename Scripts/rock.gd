extends Node3D

var start_position : Vector3
var target_position : Vector3
var damage : int = 2
var damage_radius : float = 3.0
var flight_time : float = 1.0
var arc_height : float = 3.0
var elapsed : float = 0.0

func _process(delta: float) -> void:
	elapsed += delta
	var t = elapsed / flight_time

	if t >= 1.0:
		land()
		return

	var horizontal = start_position.lerp(target_position, t)
	var height_offset = arc_height * 4 * t * (1 - t)
	global_position = Vector3(horizontal.x, horizontal.y + height_offset, horizontal.z)

func land() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if is_instance_valid(enemy) and global_position.distance_to(enemy.global_position) <= damage_radius:
			if enemy.has_method("take_damage"):
				enemy.take_damage(damage)
	queue_free()
