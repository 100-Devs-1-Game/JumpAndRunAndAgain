extends Node

### GLOBAL VARIABLES
# SCORES
var score
var highscore

# WORLD/CONTROL PROPERTIES
var worldspeed
var speedmodifier

# DEBUG ANIMATION DETECTION
var currentanim


### GAME FUNCTIONS
## COLLISION CONTACT

# NOTE: SHOW DEATH MENU AND CHANGE SPRITE TO STATIC DEATH ON CONTACT WITH ENEMY/HAZARD
# TODO: FINISH IMPLEMENTING DEATH SPRITE (TBM)
func death():
	# stop player movement and display death sprite
	$Camera2D/DeathScreen.visible = true
	# death screen retry and credits still to be implemented

# NOTE: RESTART PLAYER FROM DEFINED POSITION AND RESET WORLD PROPERTIES & SCORE TO DEFAULT VALUES
# TODO: WRITE
func start():
	# set player position to starting location
	# reset variable values
	null

# NOTE: INCREASE WORLD SPEED ON COMPLETION OF LOOP
# TODO: WRITE
func loop():
	null


# NOTE: UPDATES EVERY SECOND(?)
func _process(delta):
	
	### CONTROL SYSTEMS
	## CAMERA
	
	# NOTE: HAVE CAMERA FOLLOW PLAYER BUT NOT CENTRED UNTIL A CERTAIN DISTANCE FROM STARTING WALL
	# TODO: WRITE
	null
	
	# NOTE: CHANGES DEBUG VISIBILITY
	if Input.is_action_just_pressed("DebugPreview"):
		print("0 pressed")
		if $Camera2D/Debug.visible == false:
			$Camera2D/Debug.visible = true
			print("debug visible")
		else: $Camera2D/Debug.visible = false
