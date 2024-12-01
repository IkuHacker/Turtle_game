extends CharacterBody2D

func _ready():
	$Animations.play("Walk")

func _process(delta):
	var Direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = Direction * 200
	move_and_slide()
