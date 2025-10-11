extends Area2D

signal collected

@export var greyed_out: Color
@export var respawn_rate: float = 1.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var loop_component: LoopComponent = $LoopComponent

var can_collect := true


func _ready() -> void:
	var game: Game = get_tree().current_scene
	assert(game)
	
	game.player_entered_new_loop.connect(activate.bind(true))
	game.player_entered_current_loop.connect(activate.bind(true))
	game.player_entered_previous_loop.connect(activate.bind(false))

		
func reset():
	animated_sprite.play("default")


func activate(flag: bool):
	can_collect = flag
	var color: Color
	if flag:
		color = Color.WHITE
	else:
		color = greyed_out

	loop_component.set_property(animated_sprite, "modulate", color)


func _on_body_entered(_body: Node2D) -> void:
	if not can_collect:
		return
		
	can_collect = false
	animated_sprite.play("empty")
	collected.emit()
	await get_tree().create_timer(respawn_rate).timeout
	animated_sprite.play("default")
	loop_component.set_property(animated_sprite, "modulate", greyed_out)
