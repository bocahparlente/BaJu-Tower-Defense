extends Area3D

@export var gold_reward : int = 5
var health : int = 3
@export var speed : float = 2.0

func _ready() -> void:
	add_to_group("enemies")
	
func _process(delta: float) -> void:
	get_parent().progress += speed * delta
	if get_parent().progress_ratio >= 1.0:
		enemy_escaped()

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	var main = get_tree().current_scene
	if main.has_method("enemy_died"):
		main.enemy_died(gold_reward)
	get_parent().queue_free()

func enemy_escaped() -> void:
	var main = get_tree().current_scene
	if main.has_method("enemy_escaped"):
		main.enemy_escaped()
	get_parent().queue_free()
