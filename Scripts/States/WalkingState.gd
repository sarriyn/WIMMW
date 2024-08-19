extends State;
class_name WalkingState;

var playerControllerReference : PlayerController;
var playerStateController : PlayerStateController;
var isWalking : bool;
var threshold : float;#what is considered PlayerVelocity.ZERO but isn't actually PlayerVelocity.ZERO

func _to_string() -> String:
	return super._to_string() + "WalkingState";

func _init(pCR : PlayerController, pSC : PlayerStateController) -> void:
	playerControllerReference = pCR;
	playerStateController = pSC;
	isWalking = false;
	threshold = 0.7;

func SetState() -> void:
	isWalking = !isWalking;

func GetState() -> bool:
	return isWalking;

func _process(delta: float) -> void:
	pass

func StateLogic() -> void:
	var playerVelocity = playerControllerReference.velocity
	print(absf(playerVelocity.x + playerVelocity.z), " walking")
	if playerControllerReference.is_on_floor():
		if absf(playerVelocity.x + playerVelocity.z) >= threshold: #takes the velocity.x and .z of the player and returns a positive value for comparrison of the threshold of what is considered "moving"
			playerStateController.ChangeState("WalkingState") #changes the player state
		else:
			playerStateController.ChangeState("IdleState")
