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
	# Vérifie l'autorité dans un environnement multijoueur.
	if is_multiplayer_authority():
		# Obtenir la direction d'entrée et normaliser pour éviter une vitesse trop rapide en diagonale.
		var input_dir = Vector2(
			Input.get_axis("move_left", "move_right"),
			Input.get_axis("move_up", "move_down")
		).normalized()

		# Si une direction est enfoncée, on accélère vers la vitesse cible dans cette direction.
		if input_dir != Vector2.ZERO:
			velocity = velocity.move_toward(input_dir * SPEED, ACCELERATION * delta)
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_h = input_dir.x < 0  # Inverse le sprite si on va vers la gauche
			$AnimatedSprite2D.flip_v = input_dir.y < 0  # Inverse le sprite si on va vers la gauche

		else:
			# Si aucune direction n'est enfoncée, applique une décélération pour arrêter progressivement.
			velocity = velocity.move_toward(Vector2.ZERO, DECELERATION * delta)
			$AnimatedSprite2D.animation = "idle"

		# Appliquer la vitesse pour déplacer le personnage.
		move_and_slide()
