extends Control

@export var game: Game


func _on_retry_button_pressed():
	pass # Replace with function body.

# NOTE: SHOW CREDITS
func _on_credits_button_pressed():
	$Credits.visible = true

# NOTE: HIDE CREDITS
func _on_texture_button_pressed():
	$Credits.visible = false
