class_name Player
extends PlatformerController2D

signal died

## Player can't be killed ( only works in debug version )
@export var god_mode: bool = false
## Will die below this height
@export var max_fall_depth: float= 900.0

@onready var camera: Camera2D = $Camera2D
@onready var audio_player_running: AudioStreamPlayer = $"AudioStreamPlayer Running"
@onready var audio_player_death: AudioStreamPlayer = $"AudioStreamPlayer Death"



func _ready():
	super()
	if not OS.is_debug_build():
		god_mode= false


func _physics_process(delta):
	super(delta)
	if position.y > max_fall_depth:
		kill()

	if is_zero_approx(velocity.length()) or not is_on_floor():
		audio_player_running.stop()
	else:
		if not audio_player_running.playing:
			audio_player_running.pitch_scale= maxSpeed / 400.0
			audio_player_running.play()


func kill():
	if god_mode:
		return

	anim.play("die")
	audio_player_running.stop()
	audio_player_death.play()
	set_process(false)
	set_physics_process(false)
	collision_layer= 0
	died.emit()
