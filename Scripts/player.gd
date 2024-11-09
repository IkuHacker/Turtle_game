extends CharacterBody2D

@export var SPEED = 300.0  # Vitesse maximale
@export var ACCELERATION = 1000.0  # Taux d'accélération
@export var DECELERATION = 800.0  # Taux de décélération


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
	 # Activer ou désactiver la caméra selon si c'est le joueur local ou non
	if is_multiplayer_authority():
		# Activer la caméra pour le joueur local
		$Camera2D.enabled = true
	else:
		# Désactiver la caméra pour les autres joueurs
		$Camera2D.enabled = false

func _physics_process(delta: float) -> void:
	$AnimationPlayer.play()
	if is_multiplayer_authority():

		var input_dir = Vector2(
			Input.get_axis("move_left", "move_right"),
			Input.get_axis("move_up", "move_down")
		).normalized()

		# Si une direction est enfoncée, on accélère vers la vitesse cible dans cette direction.
		if input_dir != Vector2.ZERO:
			velocity = velocity.move_toward(input_dir * SPEED, ACCELERATION * delta)
			$AnimationPlayer.current_animation = "walk"
			$Sprite2D.flip_h = input_dir.x > 0  # Inverse le sprite si on va vers la gauche

		else:
			# Si aucune direction n'est enfoncée, applique une décélération pour arrêter progressivement.
			velocity = velocity.move_toward(Vector2.ZERO, DECELERATION * delta)
			$AnimationPlayer.current_animation = "idle"

		# Appliquer la vitesse pour déplacer le personnage.
		move_and_slide()
