extends Control

signal change_player_stats(increase: bool)


@export var game: Game

func _process(_delta: float):
	%PlayerSpeedLabel.text = "PLAYER SPEED: %d" % int(game.player.maxSpeedLock)
	%PlayerJumpHeightLabel.text = "PLAYER JUMP HEIGHT: %.1f" % game.player.jumpHeight
	#$AnimationLabel.text = "currently playing " + game.currentanim + "animation"
	$ScoreLabel.text = "SCORE = " + str(game.score)
	$HighscoreLabel.text = "HIGHSCORE = " + str(game.highscore)


func _on_increase_button_pressed():
	change_player_stats.emit(true)


func _on_decrease_button_pressed():
	change_player_stats.emit(false)
