extends CharacterBody2D

@export var speed: float = 300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var loop_component: LoopComponent = $LoopComponent

var dir := -1



func _physics_process(delta: float) -> void:
	var collision := move_and_collide(speed * Vector2(dir, 0) * delta)
	if collision:
		flip()


func flip():
	dir *= -1
	loop_component.set_property(animated_sprite, "flip_h", not animated_sprite.flip_h)
