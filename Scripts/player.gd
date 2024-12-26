extends CharacterBody2D

@export var Speed = 200.0  # [Float] Vitesse maximale
@export var Acceleration = 1000.0  # [Float] Taux d'accélération
@export var Deceleration = 1200.0  # [Float] Taux de décélération
var Velocity = Vector2()
var MousePos = null

# [Func] Gère le multijoueur
func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
	 # Activer ou désactiver la caméra selon si c'est le joueur local ou non
	if is_multiplayer_authority():
		# Activer la caméra pour le joueur local
		$Camera2D.enabled = true
		$CollisionShape2D.disabled = false

	else:
		# Désactiver la caméra pour les autres joueurs
		$Camera2D.enabled = false
		$CollisionShape2D.disabled = true

func _physics_process(delta):
	position = get_global_mouse_position()
	print(position == get_global_mouse_position())
