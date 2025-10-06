extends Control

@export var game: Game

func _process(_delta: float):
	$WorldSpeedLabel.text = "WORLD SPEED = x" + str(game.worldspeed)
	#$AnimationLabel.text = "currently playing " + game.currentanim + "animation"
	$ScoreLabel.text = "SCORE = " + str(game.score)
	$HighscoreLabel.text = "HIGHSCORE = " + str(game.highscore)


func _on_increase_button_pressed():
	game.worldspeed += game.speedmodifier

func _on_decrease_button_pressed():
	game.worldspeed -= game.speedmodifier
