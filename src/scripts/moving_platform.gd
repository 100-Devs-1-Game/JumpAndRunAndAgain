extends AnimatableBody2D

@export var move_speed: float = 50
@export var dir: int= 1
 
@onready var path_follow: PathFollow2D = get_parent()


func _physics_process(delta: float) -> void:
	path_follow.progress += move_speed * delta * dir
	if path_follow.progress_ratio <= 0 or path_follow.progress_ratio >= 1:
		dir*= -1
