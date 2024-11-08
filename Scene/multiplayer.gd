extends Node2D


var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_host_button_pressed() -> void:
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	$Host_Button.visible = false
	$Join_Button.visible = false
	
	
	
	
	
func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	


func _on_join_button_pressed() -> void:
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer
	$Host_Button.visible = false
	$Join_Button.visible = false
	
func _on_peer_connected(id):
	add_player(id)

func _on_peer_disconnected(id):
	print("Joueur déconnecté : ", id)
	
