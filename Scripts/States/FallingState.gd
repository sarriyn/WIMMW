extends State;
class_name FallingState;

var isFalling : bool;

func _init(pCR : PlayerController, pSC : PlayerStateController) -> void:
	playerControllerReference = pCR;
	playerStateController = pSC;
	isFalling = false;
	anime = playerControllerReference.get_node("Neck/SAS/AnimationPlayer");
	playerVelocity = playerControllerReference.velocity;

func _to_string() -> String:
	return "FallingState";

func SetState() -> void:
	isFalling = !isFalling;

func GetState() -> bool:
	return isFalling;
