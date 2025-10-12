extends CharacterBody2D

@export var move_speed: float = 100

@onready var path_follow: PathFollow2D = get_parent()
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var loop_component: LoopComponent = $LoopComponent

var dir := -1


func _ready() -> void:
	assert(path_follow)
	set_physics_process(false)
	await loop_component.initialized
	set_physics_process(true)
	

func _physics_process(delta: float) -> void:
	var prev_x: float = global_position.x
	path_follow.progress += move_speed * delta * dir
	if ( global_position.x > prev_x and not animated_sprite.flip_h )\
		or ( global_position.x < prev_x and animated_sprite.flip_h ):
			flip()
			
	if path_follow.progress_ratio <= 0 or path_follow.progress_ratio >= 1:
		dir *= -1

func flip():
	loop_component.set_property(animated_sprite, "flip_h", not animated_sprite.flip_h)
