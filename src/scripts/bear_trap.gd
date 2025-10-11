extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _on_killzone_triggered() -> void:
	animated_sprite.play("triggered")
