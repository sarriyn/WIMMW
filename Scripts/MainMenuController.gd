extends Node

@export var mainSceneReference : PackedScene; # Only a reference, not instantiated
@export var playerSceneReference : PackedScene; # Only a reference, not instantiated

var isSingleplayer : bool;
var peer : ENetMultiplayerPeer;
var mainScene : Node3D;
var playerScene : CharacterBody3D;
var address : LineEdit;

# Called immediately after MainMenu is put into the scene tree
func _ready() -> void:
	isSingleplayer = false; # This is a temporary solution to make the player restart the game if they want to play multiplayer
	address = $Address; # This is the address text button the player can put an IP address into
	peer = ENetMultiplayerPeer.new(); # We create the multiplayer peer for this specific game instance

# Creates the main.tscn scene, adds it to the scene tree, and hides the MainMenu
func SpawnWorld() -> void:
	self.visible = false;
	mainScene = mainSceneReference.instantiate();
	call_deferred("add_child", mainScene);

# Creates the player.tscn scene, adds it to the scene tree, sets the name to the network id, and positions it on the map
func SpawnPlayer(id : int = 1) -> void:
	playerScene = playerSceneReference.instantiate();
	playerScene.name = str(id);
	mainScene.get_node("level1").call_deferred("add_child", playerScene);

# Called when the player presses the Singleplayer button in the main menu
# Spawns the world, and spawns their player
func onSingleplayerPressed() -> void:
	isSingleplayer = true;
	SpawnWorld(); # This function must always be called first before SpawnPlayer
	SpawnPlayer();

# Called when the player presses the Host button in the main menu
# Creates the server, spawns the world and their local player
# Any player that connects, the function SpawnPlayer will run on their computer and the host's (with network ID as parameter)
func onHostPressed() -> void:
	if not isSingleplayer:
		peer.create_server(9001);
		multiplayer.multiplayer_peer = peer; # Set the multiplayer peer to the one instantiated earlier
		multiplayer.peer_connected.connect(SpawnPlayer); # Upon a person connecting, call SpawnPlayer
		SpawnWorld();
		SpawnPlayer(); # Spawn the host's player

# Called when the player presses the Join button in the main menu
# Creates the client and joins the host's server
# Spawns the world for the player joining
func onJoinPressed() -> void:
	if not isSingleplayer:
		if address.text.length() > 0:
			SpawnWorld();
			peer.create_client(address.text, 9001);
			multiplayer.multiplayer_peer = peer;
		else:
			SpawnWorld();
			peer.create_client("localhost", 9001);
			multiplayer.multiplayer_peer = peer;
