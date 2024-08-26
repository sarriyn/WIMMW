extends State;
class_name FallingState;

var isFalling : bool;

func _init(pCR : PlayerController, pSC : PlayerStateController) -> void:
	playerControllerReference = pCR;
	playerStateController = pSC;
	anime = playerControllerReference.get_node("Neck/SAS/AnimationPlayer");
	playerVelocity = playerControllerReference.velocity;
	isFalling = false;

func _to_string() -> String:
	return "FallingState";

func SetState() -> void:
	isFalling = !isFalling;

func GetState() -> bool:
	return isFalling;

func Update() -> void:
	# If in FallingState, play the "falling" animation, but also from here
	# It's possible to begin idle (we landed), but it's NOT possible to be running
	# Or it can be.. but convoluted
	anime.play("falling", -1, 2.0, false);
	if playerControllerReference.velocity == Vector3.ZERO and playerControllerReference.is_on_floor(): # We landed this frame
		anime.play("IDLESideArm", -1, 2.0, false); # NOTE, if already in FallingState, we reset the animation
		playerStateController.ChangeState("IdleState");
