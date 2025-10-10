class_name Player
extends PlatformerController2D

signal died

## Player can't be killed ( only works in debug version )
@export var god_mode: bool = false

@onready var camera: Camera2D = $Camera2D


func _ready():
	super()
	if not OS.is_debug_build():
		god_mode= false
		

func kill():
	if god_mode:
		return

	anim.play("idle")
	rotate(-PI / 2)
	set_process(false)
	set_physics_process(false)
	collision_layer= 0
	died.emit()
