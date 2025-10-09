class_name Player
extends PlatformerController2D

signal died

@onready var camera: Camera2D = $Camera2D


func kill():
	anim.play("idle")
	rotate(-PI / 2)
	set_process(false)
	set_physics_process(false)
	collision_layer= 0
	died.emit()
