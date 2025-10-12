class_name Game
extends Node

signal player_entered_new_loop
signal player_entered_current_loop
signal player_entered_previous_loop


## Flat value for increasing the players speed for each iteration
@export var speed_increase_per_iteration: float = 20
## Flat value for increasing the players jump height for each iteration 
@export var jump_increase_per_iteration: float = .1

@onready var player: Player = $Player

### GLOBAL VARIABLES
# SCORES
var score: int

# Current loop the player is in
var current_loop: int
# Maximum loop the player was in during this run
var max_loop: int

### GAME FUNCTIONS
## COLLISION CONTACT

func _ready() -> void:
	%PauseButton.show()
	if OS.is_debug_build():
		%Debug.show()

# NOTE: SHOW DEATH MENU AND CHANGE SPRITE TO STATIC DEATH ON CONTACT WITH ENEMY/HAZARD
# TODO: FINISH IMPLEMENTING DEATH SPRITE (TBM)
func death():
	# stop player movement and display death sprite
	if score > Global.highscore:
		Global.highscore= score
	$CanvasLayer/DeathScreen.visible = true

# NOTE: INCREASE PLAYER STATS ON COMPLETION OF LOOP
func loop(forward: bool):
	current_loop += 1 if forward else -1
	if current_loop > max_loop:
		assert(current_loop == max_loop + 1)
		max_loop = current_loop
		change_player_stats()
		player_entered_new_loop.emit()
	elif current_loop == max_loop:
		player_entered_current_loop.emit()
	else:
		player_entered_previous_loop.emit()


func change_player_stats(increase: bool= true):
	if increase:
		player.maxSpeed += speed_increase_per_iteration
		player.jumpHeight += jump_increase_per_iteration
	else:
		player.maxSpeed -= speed_increase_per_iteration
		player.jumpHeight -= jump_increase_per_iteration

	player._updateData()


# NOTE: UPDATES EVERY SECOND(?)
func _process(_delta: float):
	
	### CONTROL SYSTEMS
	## CAMERA
	
	# NOTE: HAVE CAMERA FOLLOW PLAYER BUT NOT CENTRED UNTIL A CERTAIN DISTANCE FROM STARTING WALL
	# TODO: WRITE
	
	
	# NOTE: CHANGES DEBUG VISIBILITY
	if Input.is_action_just_pressed("DebugPreview") and OS.is_debug_build():
		print("0 pressed")
		if $CanvasLayer/Debug.visible == false:
			$CanvasLayer/Debug.visible = true
			print("debug visible")
		else: 
			$CanvasLayer/Debug.visible = false
		
	# NOTE: CHANGES DEATH MENU VISABILITY
	if Input.is_action_just_pressed("MenuPreview"):
		print ("9 pressed")
		if $CanvasLayer/DeathScreen.visible == false:
			$CanvasLayer/DeathScreen.visible = true
			print ("menu visible")
		else: 
			$CanvasLayer/DeathScreen.visible = false
			
			
	if $CanvasLayer/DeathScreen.visible == true:
		%PauseButton.visible = false




func _on_pause_button_pressed():
	if $CanvasLayer/PausedText.visible == false:
		$CanvasLayer/PausedText.visible = true
		get_tree().paused = true
	else: 
		$CanvasLayer/PausedText.visible = false
		get_tree().paused = false


func _on_death_screen_request_restart() -> void:
	get_tree().reload_current_scene()


func _on_level_carrot_collected() -> void:
	score+= 1
