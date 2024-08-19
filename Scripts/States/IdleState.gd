extends State;
class_name IdleState;

var playerControllerReference : PlayerController;
var playerStateController : PlayerStateController;
var isIdle : bool;
var threshold : float;

func _init(pCR : PlayerController, pSC : PlayerStateController) -> void:
	playerControllerReference = pCR
	playerStateController = pSC
	isIdle = true;
	threshold = 0.7;

func _to_string() -> String:
	return super._to_string() + "IdleState";

func SetState() -> void:
	isIdle = !isIdle;

func GetState() -> bool:
	return isIdle;

func StateLogic() -> void:
	var playerVelocity = playerControllerReference.velocity
	print(absf(playerVelocity.x + playerVelocity.z), " idle")
	if playerControllerReference.is_on_floor():
		if absf(playerVelocity.x + playerVelocity.z) >= threshold: #takes the velocity.x and .z of the player and returns a positive value for comparrison of the threshold of what is considered "moving"
			playerStateController.ChangeState("WalkingState") #changes the player state
		else:
			playerStateController.ChangeState("IdleState")
