extends Line2D


func _process(_delta: float) -> void:
	position.y = sin(Engine.get_physics_frames() / 100.0) * 100
