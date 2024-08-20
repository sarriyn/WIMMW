extends Node;
class_name State;

var playerControllerReference : PlayerController;
var threshold : float = 0.7;
var playerStateController : PlayerStateController;

func Enter() -> void:
	pass;

func Exit() -> void:
	pass;

func Update() -> void:
	var playerVelocity = playerControllerReference.velocity
	print(absf(playerVelocity.x + playerVelocity.z), " walking")
	if playerControllerReference.is_on_floor():
		if absf(playerVelocity.x + playerVelocity.z) >= threshold: #takes the velocity.x and .z of the player and returns a positive value for comparrison of the threshold of what is considered "moving"
			playerStateController.ChangeState("WalkingState") #changes the player state
		else:
			playerStateController.ChangeState("IdleState")

func PhysicsUpdate(_delta : float) -> void:
	pass;
