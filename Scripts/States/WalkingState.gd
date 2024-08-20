extends State;
class_name WalkingState;

var isWalking : bool;

func _to_string() -> String:
	return "WalkingState";

func _init(pCR : PlayerController, pSC : PlayerStateController) -> void:
	playerControllerReference = pCR;
	playerStateController = pSC;
	isWalking = false;

func SetState() -> void:
	isWalking = !isWalking;

func GetState() -> bool:
	return isWalking;
