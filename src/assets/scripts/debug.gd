extends Control

func _process(delta):
	$WorldSpeedLabel.text = "WORLD SPEED = x" + GM.worldspeed
	$AnimationLabel.text = "currently playing " + GM.currentanim + "animation"
	$ScoreLabel.text = "SCORE = " + GM.score
	$HighscoreLabel.text = "HIGHSCORE = " + GM.highscore


func _on_increase_button_pressed():
	GM.worldspeed += GM.speedmodifier

func _on_decrease_button_pressed():
	GM.worldspeed -= GM.speedmodifier
