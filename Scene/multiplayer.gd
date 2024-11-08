extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

# Fonction pour démarrer le serveur
func _on_host_button_pressed() -> void:
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	print(multiplayer.get_instance_id())
	add_player()
	$Host_Button.visible = false
	$Join_Button.visible = false

# Fonction pour ajouter un joueur
func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	
	# Ajouter le joueur à la scène
	call_deferred("add_child", player)
	
	# Vérifier si c'est le joueur local et activer sa caméra
	if multiplayer.get_unique_id() == id or multiplayer.is_server():
		 # Récupérer le nœud de la caméra
		var camera = player.get_node("Camera2D")  # Assure-toi que le chemin est correct

		# Vérification de type et de présence
		if camera:
			print("Caméra trouvée : ", camera)
			if camera is Camera2D:
				camera.make_current()
			else:
				print("Erreur : Le nœud trouvé n'est pas de type Camera2D.")
			
# Fonction pour rejoindre en tant que client
func _on_join_button_pressed() -> void:
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer
	$Host_Button.visible = false
	$Join_Button.visible = false

func _on_peer_connected(id):
	print("Joueur connecté : ", id)

func _on_peer_disconnected(id):
	print("Joueur déconnecté : ", id)
