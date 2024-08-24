extends Node;
class_name PlayerRPCSynchronizer;

var playerController : PlayerController;
var playerStateController : PlayerStateController;

func initializeNode(pC : PlayerController, pSC : PlayerStateController) -> void:
	playerController = pC;
	playerStateController = pSC;

@rpc("call_local", "any_peer")
func UpdateStateRPC() -> void:
	playerStateController.UpdateState();
