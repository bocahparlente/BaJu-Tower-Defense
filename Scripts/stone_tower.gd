extends Node3D

@export var attack_range : float = 8.0
@export var fire_rate : float = 0.7
@export var damage : int = 2
@export var damage_radius : float = 3.0

var rock_scene = preload("res://Scenes/Mesh/Towers/rock.tscn")
var enemies_in_range : Array = []
var placing : bool = true

func _ready() -> void:
	$RangeArea.area_entered.connect(_on_range_area_entered)
	$RangeArea.area_exited.connect(_on_range_area_exited)
	$FireTimer.timeout.connect(_on_fire_timer_timeout)

func _process(_delta: float) -> void:
	if placing:
		var main = get_tree().current_scene
		if main.has_method("get_ground_position"):
			var pos = main.get_ground_position()
			if pos != null:
				global_position = pos
		return

	enemies_in_range = enemies_in_range.filter(func(e): return is_instance_valid(e))
	var target = get_nearest_enemy()
	if target:
		look_at(target.global_position, Vector3.UP)

func _unhandled_input(event: InputEvent) -> void:
	if placing and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		place()

func place() -> void:
	placing = false
	$FireTimer.start()
	get_parent().tower_built()

func get_nearest_enemy() -> Node3D:
	var nearest : Node3D = null
	var nearest_dist := INF
	for enemy in enemies_in_range:
		if not is_instance_valid(enemy) or not enemy.is_inside_tree():
			continue
		var dist := global_position.distance_to(enemy.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = enemy
	return nearest

func _on_range_area_entered(area: Area3D) -> void:
	if area.has_method("take_damage"):
		enemies_in_range.append(area)

func _on_range_area_exited(area: Area3D) -> void:
	enemies_in_range.erase(area)

func _on_fire_timer_timeout() -> void:
	var target = get_nearest_enemy()
	if target == null:
		return
	var rock = rock_scene.instantiate()
	get_tree().current_scene.add_child(rock)
	rock.start_position = global_position
	rock.target_position = target.global_position
	rock.damage = damage
	rock.damage_radius = damage_radius
