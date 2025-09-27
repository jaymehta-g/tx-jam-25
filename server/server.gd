class_name Server
extends Node




func _ready() -> void: 
    # get the default multiplayerAPI object. 
    get_tree().get_multiplayer()
    host()


func host() -> void:
    #server peer
    var peer = ENetMultiplayerPeer.new()
    peer.create_server(PORT, MAX_CLIENTS)
    multiplayer.multiplayer_peer = peer


func _on_exit() -> void: 
    multiplayer.multiplayer_peer = null

