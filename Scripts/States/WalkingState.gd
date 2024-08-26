extends State;
class_name WalkingState;

var isWalking : bool;

func _init(pCR : PlayerController, pSC : PlayerStateController) -> void:
	playerControllerReference = pCR;
	playerStateController = pSC;
	anime = playerControllerReference.get_node("Neck/SAS/AnimationPlayer");
	playerVelocity = playerControllerReference.velocity;
	isWalking = false;

func _to_string() -> String:
	return "WalkingState";

func SetState() -> void:
	isWalking = !isWalking;

func GetState() -> bool:
	return isWalking;

func Update() -> void:
	# If in WalkingState, play the "walk" animation, but also from here
	# It's posible to begin falling (walk off the edge)
	# It's also possible to begin being idle, because you can stop moving
	anime.play("walk", -1, 2.0, false); # NOTE, if already in WalkingState, we reset the animation
	if not playerControllerReference.is_on_floor() and (absf(playerControllerReference.velocity.y) > 0):
		anime.play("falling", -1, 2.0, false);
		playerStateController.ChangeState("FallingState");
	elif (absf(playerControllerReference.velocity.x) + absf(playerControllerReference.velocity.z)) == 0:
		anime.play("IDLESideArm", -1, 2.0, false);
		playerStateController.ChangeState("IdleState");
