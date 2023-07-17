extends KinematicBody

##############################################
# Normal vars
##############################################
var fullContact = false # : 
var mouseSensitivity = 0.03 # : Self-explanitory | MOUSE-RELATED
var playerSpeed = 10 # : The speed at which the player will move | HORIZONTAL
var direction = Vector3() # : The direction in which the player is moving | VECTOR3
var horizAcelleration = 6 # : Acceleration in the horizontal direction | INTEGER
var horizVelocity = Vector3() # : Acceleration in the vertical direction | VECTOR3
var movement = Vector3() # : The players movement/direction | VECTOR3
var gravity = 20 # : The gravity of the world | INTEGER
var jumpHeight = 10 # : The height of the jump | INTEGER
var gravityVec = Vector3() # : The gravity in a vector | VECTOR3
var visibleMouse = false
onready var playerHead = $Head_Player # : A reference to the Head_Player object | OBJECT
onready var isGrounded = $IsGrounded # : A reference to the IsGrounded object | OBJECT


var _save: SaveGame


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	createLoadSave()
	




# Every physics frame
func _physics_process(delta):

	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("ui_cancel") and visibleMouse == true:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		visibleMouse = false
	
	
	if Input.is_action_just_pressed("save"):
		_save.speed = playerSpeed
		_save.save()
	elif Input.is_action_just_pressed("load"):
		SaveGame.load()
	
	
	_movement(delta)


# Whenever there is an input event
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouseSensitivity)) # translates horizontal mouse movement into horizontal looking
		playerHead.rotate_x(deg2rad(-event.relative.y * mouseSensitivity)) # same as above but opposite
		playerHead.rotation.x = clamp(playerHead.rotation.x, deg2rad(-89), deg2rad(89)) # stops you doing a 360 vertically


func createLoadSave() -> void:
	if SaveGame.saveExists():
		_save = SaveGame.load() as SaveGame
		playerSpeed = _save.speed
		_updateSpeedBar(playerSpeed)
	else:
		_save = SaveGame.new()
		_save.speed = playerSpeed
		_save.saveGame()

	playerSpeed = _save.speed



func _movement(d) -> void:
	direction = Vector3()
	
	if isGrounded.is_colliding():
		fullContact = true
	else:
		fullContact = false


	# Jump stuff
	if not is_on_floor():
		gravityVec += Vector3.DOWN * gravity * d
	elif is_on_floor() and fullContact:
		gravityVec = -get_floor_normal() * gravity
	else:
		gravityVec = -get_floor_normal()
	
	if Input.is_action_just_pressed("moveJump") and (is_on_floor() or isGrounded.is_colliding()):
		gravityVec = Vector3.UP * jumpHeight



	# Forwards and backwards
	if Input.is_action_pressed("moveForward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("moveBackward"):
		direction += transform.basis.z
	# Left and right
	if Input.is_action_pressed("moveLeft"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("moveRight"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	horizVelocity = horizVelocity.linear_interpolate(direction * playerSpeed, horizAcelleration * d)
	movement.z = horizVelocity.z + gravityVec.z
	movement.x = horizVelocity.x + gravityVec.x
	movement.y = gravityVec.y
	move_and_slide(movement, Vector3.UP)


func _on_SaveButton_pressed():
	print("saved game")
	_save.speed = playerSpeed
	_save.saveGame()


func _on_LoadButton_pressed():
	print("loaded game")
	_save = SaveGame.load() as SaveGame
	playerSpeed = _save.speed
	_updateSpeedBar(playerSpeed)


func _updateSpeedBar(speed: int) -> void:
	$StatsEdit/SpeedSlider.value = speed
