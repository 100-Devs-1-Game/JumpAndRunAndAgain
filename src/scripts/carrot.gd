extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func reset():
	animated_sprite.play("default")

func _on_body_entered(_body: Node2D) -> void:
	animated_sprite.play("empty")
