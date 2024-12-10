extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
@export var max_player_count_in_game: int = 5

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
	$HUD/Host_Button.visible = false
	$HUD/Join_Button.visible = false
	$HUD/PlayerCount.text = str(multiplayer.get_peers().size() + 1) + "/" + str(max_player_count_in_game)

# Fonction pour ajouter un joueur
func add_player(id = 1):
	# Vérifie si le nombre de joueurs atteint la limite
	if multiplayer.get_peers().size() + 1 > max_player_count_in_game:
		print("Le nombre maximum de joueurs est atteint. Impossible de rejoindre.")
		multiplayer.disconnect_peer(id) 
		return  # Annule l'ajout du joueur si la limite est atteinte

	var player = player_scene.instantiate()
	player.name = str(id)
	
	# Ajouter le joueur à la scène
	call_deferred("add_child", player)
	

# Fonction pour rejoindre en tant que client
func _on_join_button_pressed() -> void:
	if multiplayer.get_peers().size() + 1 >= max_player_count_in_game:
		print("Impossible de rejoindre, le nombre maximum de joueurs est atteint.")
		return  # Annule la tentative de rejoindre si le nombre est atteint
	
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer
	$HUD/Host_Button.visible = false
	$HUD/Join_Button.visible = false

func _on_peer_connected(id):
	print("Nombre de joueurs connectés :", multiplayer.get_peers().size() + 1)
	$HUD/PlayerCount.text = str(multiplayer.get_peers().size() + 1) + "/" + str(max_player_count_in_game)

func _on_peer_disconnected(id):
	print("Joueur déconnecté : ", id)
	var player_to_remove = get_node_or_null(str(id))
	if player_to_remove:
		player_to_remove.queue_free()  # Supprimer le joueur de la scène
	$HUD/PlayerCount.text = str(multiplayer.get_peers().size() + 1) + "/" + str(max_player_count_in_game)
