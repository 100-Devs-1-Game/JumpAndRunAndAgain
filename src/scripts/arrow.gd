extends Polygon2D


func _ready() -> void:
	var game: Game = get_tree().current_scene
	assert(game)
	
	game.player_entered_new_loop.connect(blink)


func blink():
	var interval: float = 0.1
	for i in 2:
		await get_tree().create_timer(interval).timeout
		hide()
		await get_tree().create_timer(interval).timeout
		show()
