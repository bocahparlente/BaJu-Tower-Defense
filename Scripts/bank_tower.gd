extends Node3D

@export var income_amount : int = 5
@export var income_interval : float = 3.0

var floating_text_scene = preload("res://Scenes/Mesh/Towers/floating_text.tscn")
var placing : bool = true

func _ready() -> void:
	$IncomeTimer.wait_time = income_interval
	$IncomeTimer.timeout.connect(_on_income_timer_timeout)

func _process(_delta: float) -> void:
	if placing:
		var main = get_tree().current_scene
		if main.has_method("get_ground_position"):
			var pos = main.get_ground_position()
			if pos != null:
				global_position = pos

func _unhandled_input(event: InputEvent) -> void:
	if placing and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		place()

func place() -> void:
	placing = false
	$IncomeTimer.start()
	get_parent().tower_built()

func _on_income_timer_timeout() -> void:
	var main = get_tree().current_scene
	if main.has_method("add_money"):
		main.add_money(income_amount)
	show_floating_text()

func show_floating_text() -> void:
	var label = floating_text_scene.instantiate()
	label.text = "+$" + str(income_amount)
	label.position = Vector3(0, 2, 0)
	add_child(label)
