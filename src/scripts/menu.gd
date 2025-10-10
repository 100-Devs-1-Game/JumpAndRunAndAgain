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
