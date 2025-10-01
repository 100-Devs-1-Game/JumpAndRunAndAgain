extends Control

func _process(_delta: float):
	$WorldSpeedLabel.text = "WORLD SPEED = x" + str(GM.worldspeed)
	#$AnimationLabel.text = "currently playing " + GM.currentanim + "animation"
	$ScoreLabel.text = "SCORE = " + str(GM.score)
	$HighscoreLabel.text = "HIGHSCORE = " + str(GM.highscore)


func _on_increase_button_pressed():
	GM.worldspeed += GM.speedmodifier

func _on_decrease_button_pressed():
	GM.worldspeed -= GM.speedmodifier
