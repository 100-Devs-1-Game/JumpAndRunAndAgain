extends CharacterBody2D

@export var move_speed: float= 100

@onready var path_follow: PathFollow2D= get_parent()
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var loop_component: LoopComponent = $LoopComponent


func _ready() -> void:
	assert(path_follow)

func _physics_process(delta: float) -> void:
	path_follow.progress+= move_speed * delta * ( 1 if animated_sprite.flip_h else -1 )
	if path_follow.progress_ratio <= 0 or path_follow.progress_ratio >= 1:
		flip()

func flip():
	loop_component.set_property(animated_sprite, "flip_h", not animated_sprite.flip_h)
