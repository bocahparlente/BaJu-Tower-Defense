extends Label3D

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector3(0, 1, 0), 1.0)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 1.0)
	tween.finished.connect(queue_free)
