extends Panel


onready var playerSpeed = get_parent().playerSpeed
onready var newSpeed = $SpeedSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	print(playerSpeed)

func _input(event):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_parent().playerSpeed = newSpeed.value



