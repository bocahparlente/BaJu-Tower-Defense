extends Node3D

var target : Node3D
@export var speed : float = 4.0
@export var damage : int = 1

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		queue_free()
		return

	var direction = (target.global_position - global_position).normalized()
	look_at(global_position + direction, Vector3.UP)
	global_position += direction * speed * delta

	if global_position.distance_to(target.global_position) < 1.0:
		hit_target()

func hit_target() -> void:
	if is_instance_valid(target) and target.has_method("take_damage"):
		target.take_damage(damage)
	queue_free()
