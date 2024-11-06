extends CharacterBody2D

@export var SPEED = 300.0  # Vitesse maximale
@export var JUMP_VELOCITY = -400.0  # Vitesse de saut
@export var ACCELERATION = 1000.0  # Taux d'accélération
@export var DECELERATION = 800.0  # Taux de décélération
var isJumping: bool = false


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play()

	if is_multiplayer_authority():
		
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Gérer le saut.
		if Input.is_action_pressed("jump") and is_on_floor() and not isJumping:
			velocity.y = JUMP_VELOCITY
			isJumping = true
			await get_tree().create_timer(0.1).timeout
			isJumping = false

	# Obtenir la direction d'entrée et gérer l'accélération/décélération.
		var direction := Input.get_axis("move_left", "move_right")
		if direction != 0:
		# Si une direction est enfoncée, on accélère vers SPEED dans cette direction.
			velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
			$AnimatedSprite2D.animation = "walk"
		else:
		# Sinon, on applique la décélération pour ramener la vitesse horizontale vers zéro.
			velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
			$AnimatedSprite2D.animation = "idle"
		
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0


	# Appliquer le mouvement.
	move_and_slide()
