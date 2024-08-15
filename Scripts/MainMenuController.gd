extends Node

@export var mainSceneReference : PackedScene;
@export var playerSceneReference : PackedScene;

var isSingleplayer : bool;
var peer : ENetMultiplayerPeer;
var mainScene : Node3D;
var playerScene : CharacterBody3D;

var address : LineEdit;

func _ready() -> void:
	isSingleplayer = false; # This is a temporary solution to make the player restart the game if they want to play multiplayer
	address = $Address;
	peer = ENetMultiplayerPeer.new();

func SpawnWorld() -> void:
	self.visible = false;
	mainScene = mainSceneReference.instantiate();
	call_deferred("add_child", mainScene);

func SpawnPlayer(id : int = 1) -> void:
	playerScene = playerSceneReference.instantiate();
	playerScene.name = str(id);
	mainScene.get_node("level1").call_deferred("add_child", playerScene);
	playerScene.position = Vector3(-6, 3, -111);

func onSingleplayerPressed() -> void:
	isSingleplayer = true;
	SpawnWorld(); # This function must always be called first before SpawnPlayer
	SpawnPlayer();

func onHostPressed() -> void:
	if not isSingleplayer:
		peer.create_server(9001);
		multiplayer.multiplayer_peer = peer; # Set the multiplayer peer to the one instantiated earlier
		multiplayer.peer_connected.connect(SpawnPlayer); # Upon a person connecting, call SpawnPlayer
		SpawnWorld();
		SpawnPlayer(); # Spawn the host's player

func onJoinPressed() -> void:
	if not isSingleplayer:
		if address.text.length() > 0:
			peer.create_client(address.text, 9001);
			multiplayer.multiplayer_peer = peer;
			SpawnWorld();
		else:
			peer.create_client("localhost", 9001);
			multiplayer.multiplayer_peer = peer;
			SpawnWorld();
