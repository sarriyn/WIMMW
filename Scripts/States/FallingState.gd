extends State;
class_name FallingState;

var isFalling : bool;
var firstPersonCam : Camera3D;
var tabCam : Camera3D;

func _init(pCR : PlayerController, pSC : PlayerStateController) -> void:
	playerControllerReference = pCR;
	playerStateController = pSC;
	anime = playerControllerReference.get_node("Neck/SAS/AnimationPlayer");
	firstPersonCam = playerControllerReference.get_node("Neck/Camera3D");
	tabCam = playerControllerReference.get_node("Neck/tabCam");
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
	if playerControllerReference.velocity == Vector3.ZERO and playerControllerReference.is_on_floor() and not tabCam.current: # We landed this frame
		playerStateController.ChangeState("IdleState");
	elif tabCam.current:
		playerStateController.ChangeState("TabMenuState");
