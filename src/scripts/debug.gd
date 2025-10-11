extends Control

signal change_player_stats(increase: bool)


@export var game: Game


func _ready() -> void:
	if not OS.is_debug_build():
		hide()


func _process(_delta: float):
	%PlayerSpeedLabel.text = "PLAYER SPEED: %d" % int(game.player.maxSpeedLock)
	%PlayerJumpHeightLabel.text = "PLAYER JUMP HEIGHT: %d" % game.player.jumpMagnitude
	#$AnimationLabel.text = "currently playing " + game.currentanim + "animation"
	%ScoreLabel.text = "SCORE = " + str(game.score)
	%HighscoreLabel.text = "HIGHSCORE = " + str(Global.highscore)


func _on_increase_button_pressed():
	change_player_stats.emit(true)


func _on_decrease_button_pressed():
	change_player_stats.emit(false)
