class_name Game
extends Node

## Flat value for increasing the players speed for each iteration
@export var speed_increase_per_iteration: float = 20
## Flat value for increasing the players jump height for each iteration 
@export var jump_increase_per_iteration: float = 20

@onready var player: Player = $Player

### GLOBAL VARIABLES
# SCORES
var score: int
var highscore: int

# Current loop the player is in
var current_loop: int
# Maximum loop the player was in during this run
var max_loop: int

### GAME FUNCTIONS
## COLLISION CONTACT

# NOTE: SHOW DEATH MENU AND CHANGE SPRITE TO STATIC DEATH ON CONTACT WITH ENEMY/HAZARD
# TODO: FINISH IMPLEMENTING DEATH SPRITE (TBM)
func death():
	# stop player movement and display death sprite
	$"CanvasLayer/DeathScreen/Menu&title/ScoreText".text = "...BUT YOU COLLECTED " + str(score) + " CARROTS BEFORE YOU DID. TRY AGAIN?"
	$CanvasLayer/DeathScreen.visible = true
	# DEATH SCREEN MENU AND BUTTON IMPUTS (SANS RETRY) IMPLEMENTED

# NOTE: RESTART PLAYER FROM DEFINED POSITION AND RESET WORLD PROPERTIES & SCORE TO DEFAULT VALUES
# TODO: WRITE
func start():
	# set player position to starting location
	# reset variable values
	pass

# NOTE: INCREASE WORLD SPEED ON COMPLETION OF LOOP
# TODO: WRITE
func loop(forward: bool):
	current_loop += 1 if forward else -1
	if current_loop > max_loop:
		assert(current_loop == max_loop + 1)
		max_loop = current_loop
		change_player_stats()


func change_player_stats(increase: bool= true):
	if increase:
		player.maxSpeedLock += speed_increase_per_iteration
		player.jumpMagnitude += jump_increase_per_iteration
	else:
		player.maxSpeedLock -= speed_increase_per_iteration
		player.jumpMagnitude -= jump_increase_per_iteration



# NOTE: UPDATES EVERY SECOND(?)
func _process(_delta: float):
	
	### CONTROL SYSTEMS
	## CAMERA
	
	# NOTE: HAVE CAMERA FOLLOW PLAYER BUT NOT CENTRED UNTIL A CERTAIN DISTANCE FROM STARTING WALL
	# TODO: WRITE
	
	
	# NOTE: CHANGES DEBUG VISIBILITY
	if Input.is_action_just_pressed("DebugPreview"):
		print("0 pressed")
		if $CanvasLayer/Debug.visible == false:
			$CanvasLayer/Debug.visible = true
			print("debug visible")
		else: $CanvasLayer/Debug.visible = false
		
	# NOTE: CHANGES DEATH MENU VISABILITY
	if Input.is_action_just_pressed("MenuPreview"):
		print ("9 pressed")
		if $CanvasLayer/DeathScreen.visible == false:
			$CanvasLayer/DeathScreen.visible = true
			print ("menu visible")
		else: $CanvasLayer/DeathScreen.visible = false




func _on_pause_button_pressed():
	if $CanvasLayer/PausedText.visible == false:
		$CanvasLayer/PausedText.visible = true
		get_tree().paused = true
	else: 
		$CanvasLayer/PausedText.visible = false
		get_tree().paused = false
