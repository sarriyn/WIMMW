extends Node;
class_name PlayerRPCSynchronizer;
# THIS CLASS IS CURRENTLY NOT USED, BUT CAN REMAIN IF WE NEED TO EVER USE IT

var playerController : PlayerController;
var playerStateController : PlayerStateController;

func initializeNode(pC : PlayerController, pSC : PlayerStateController) -> void:
	playerController = pC;
	playerStateController = pSC;

@rpc("call_local", "any_peer")
func UpdateStateRPC() -> void:
	playerStateController.UpdateState();
