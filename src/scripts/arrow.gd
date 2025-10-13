extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	var game: Game = get_tree().current_scene
	assert(game)
	
	game.player_entered_new_loop.connect(on_new_loop)


func on_new_loop():
	animated_sprite.play("default")
	audio_player.play()
	await blink()
	animated_sprite.stop()


func blink():
	var interval: float = 0.1
	for i in 3:
		await get_tree().create_timer(interval).timeout
		hide()
		await get_tree().create_timer(interval).timeout
		show()
