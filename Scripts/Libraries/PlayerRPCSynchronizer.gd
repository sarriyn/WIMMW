extends MultiplayerSynchronizer;
class_name PlayerRPCSynchronizer;
# THIS CLASS IS CURRENTLY NOT USED, BUT CAN REMAIN IF WE NEED TO EVER USE IT

var playerController : PlayerController;
var playerStateController : PlayerStateController;
var playerTabMenuToggle : PlayerTabMenuToggle;

func InitializeNode(pC : PlayerController) -> void:
	playerController = pC;
	playerStateController = playerController.playerStateController;
	playerTabMenuToggle = playerController.playerInputChecker.playerTabMenuToggle;

#@rpc("any_peer", "call_local")
#func UpdateCameraCurrentRPC() -> void:
#	if playerController.name.to_int() == multiplayer.get_remote_sender_id():
#		playerTabMenuToggle.TabMenu();
