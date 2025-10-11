extends Control

signal request_restart

@export var game: Game


func _on_retry_button_pressed():
	request_restart.emit()

# NOTE: SHOW CREDITS
func _on_credits_button_pressed():
	$Credits.visible = true

# NOTE: HIDE CREDITS
func _on_texture_button_pressed():
	$Credits.visible = false


func _on_visibility_changed() -> void:
	if not is_inside_tree():
		return
	%ScoreText.text = "...BUT YOU COLLECTED %d CARROTS BEFORE YOU DID.\nCURRENT HIGHSCORE: %d\nTRY AGAIN?" % [ game.score, Global.highscore ]
